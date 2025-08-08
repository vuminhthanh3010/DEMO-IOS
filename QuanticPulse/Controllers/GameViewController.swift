import UIKit

final class GameViewController: BaseViewController {
    private let level: Level
    private let engine: GameEngine

    private var icons: [PulseIconView] = []
    private let hintsStack = UIStackView()
    private let optionsGrid = UIStackView()
    private let submitButton = UIButton(type: .system)
    private let timerView = TimerProgressView()
    private let scoreLabel = UILabel()
    private let pauseButton = UIButton(type: .system)
    private let skipButton = UIButton(type: .system)

    private var selectedOptionIndex: Int? = nil

    // Pulse state
    private var pulseTimer: Timer?
    private var currentPulse: Int = 0
    private var isAwaitingTap: Bool = false

    init(level: Level) {
        self.level = level
        self.engine = GameEngine(level: level)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = level.name
        navigationItem.hidesBackButton = true
        setupUI()
        loadNextQuestion()
    }

    private func setupUI() {
        let timeContainer = UIView()
        timeContainer.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerView.widthAnchor.constraint(equalToConstant: 44),
            timerView.heightAnchor.constraint(equalToConstant: 44),
            timerView.centerXAnchor.constraint(equalTo: timeContainer.centerXAnchor),
            timerView.centerYAnchor.constraint(equalTo: timeContainer.centerYAnchor)
        ])

        scoreLabel.textColor = ThemeManager.shared.primaryTextColor
        scoreLabel.font = .monospacedDigitSystemFont(ofSize: 16, weight: .bold)
        scoreLabel.text = "Score: 0"

        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)

        let topBar = UIStackView(arrangedSubviews: [pauseButton, timeContainer, scoreLabel, skipButton])
        topBar.axis = .horizontal
        topBar.alignment = .center
        topBar.distribution = .equalSpacing

        let iconsContainer = UIStackView()
        iconsContainer.axis = .horizontal
        iconsContainer.alignment = .fill
        iconsContainer.distribution = .fillEqually
        iconsContainer.spacing = 10

        hintsStack.axis = .vertical
        hintsStack.spacing = 6

        optionsGrid.axis = .vertical
        optionsGrid.spacing = 10

        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = ThemeManager.shared.currentTintColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 12
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        let root = UIStackView(arrangedSubviews: [topBar, iconsContainer, hintsStack, optionsGrid, submitButton])
        root.axis = .vertical
        root.spacing = 16

        view.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            root.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            root.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            root.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            root.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])

        self.iconsContainer = iconsContainer
    }

    private weak var iconsContainer: UIStackView?

    private func loadNextQuestion() {
        guard let question = engine.currentQuestion() else {
            completeLevel()
            return
        }
        selectedOptionIndex = nil
        isAwaitingTap = false
        currentPulse = 0
        pulseTimer?.invalidate()

        icons.forEach { $0.removeFromSuperview() }
        icons.removeAll()
        let n = question.numIcons
        for i in 0..<n {
            let v = PulseIconView()
            v.index = i + 1
            v.addTarget(self, action: #selector(iconTapped(_:)), for: .primaryActionTriggered)
            icons.append(v)
            iconsContainer?.addArrangedSubview(v)
        }

        hintsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for hint in question.hints {
            let l = UILabel()
            l.text = hint
            l.textAlignment = .center
            l.textColor = ThemeManager.shared.primaryTextColor
            l.font = .systemFont(ofSize: 16, weight: .medium)
            hintsStack.addArrangedSubview(l)
        }

        optionsGrid.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var optionTuples: [(String, Int)] = question.options.enumerated().map { ($0.element, $0.offset) }
        optionTuples.shuffle()
        let rows = stride(from: 0, to: optionTuples.count, by: 2).map { Array(optionTuples[$0..<min($0+2, optionTuples.count)]) }
        for row in rows {
            let h = UIStackView()
            h.axis = .horizontal
            h.spacing = 10
            h.distribution = .fillEqually
            for (title, originalIndex) in row {
                let b = UIButton(type: .system)
                b.setTitle(title, for: .normal)
                b.setTitleColor(.white, for: .normal)
                b.titleLabel?.numberOfLines = 2
                b.titleLabel?.textAlignment = .center
                b.backgroundColor = UIColor.white.withAlphaComponent(0.15)
                b.layer.cornerRadius = 10
                b.heightAnchor.constraint(equalToConstant: 48).isActive = true
                b.tag = originalIndex
                b.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
                h.addArrangedSubview(b)
            }
            optionsGrid.addArrangedSubview(h)
        }

        print("[Answer] Icon: #\(question.targetIconIndex) at pulse #\(question.targetPulseNumber)")

        scoreLabel.text = "Score: \(engine.score)"
        timerView.setProgress(0)
    }

    @objc private func optionTapped(_ sender: UIButton) {
        for row in optionsGrid.arrangedSubviews.compactMap({ $0 as? UIStackView }) {
            for case let btn as UIButton in row.arrangedSubviews {
                btn.backgroundColor = UIColor.white.withAlphaComponent(0.15)
            }
        }
        sender.backgroundColor = ThemeManager.shared.currentTintColor
        selectedOptionIndex = sender.tag
    }

    @objc private func submitTapped() {
        guard let question = engine.currentQuestion() else { return }
        guard let selection = selectedOptionIndex else {
            Toast.show(message: "Pick an option first", in: view)
            return
        }
        if selection == question.correctOptionIndex {
            SoundManager.shared.playCorrect()
            Haptic.success()
            startPulseSequence()
        } else {
            SoundManager.shared.playWrong()
            Haptic.error()
            gameOver()
        }
    }

    @objc private func pauseTapped() {
        pulseTimer?.invalidate()
        let alert = UIAlertController(title: "Paused", message: "Game is paused", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: { _ in
            self.startPulseSequence(resume: true)
        }))
        alert.addAction(UIAlertAction(title: "Home", style: .destructive, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    @objc private func skipTapped() {
        engine.applySkipPenalty()
        scoreLabel.text = "Score: \(engine.score)"
        loadNextQuestion()
    }

    private func startPulseSequence(resume: Bool = false) {
        guard let question = engine.currentQuestion() else { return }
        isAwaitingTap = true
        currentPulse = resume ? currentPulse : 0
        pulseTimer?.invalidate()
        let total = level.totalPulsesPerQuestion
        let duration = level.pulseSpeedSeconds
        let startTime = Date()

        pulseTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { [weak self] t in
            guard let self = self else { return }
            self.currentPulse += 1
            let pulseIndex = self.currentPulse
            let actives = question.fakePulses[pulseIndex] ?? []
            for (i, icon) in self.icons.enumerated() {
                let shouldLight = actives.contains(i+1) || (pulseIndex == question.targetPulseNumber && (i+1) == question.targetIconIndex)
                icon.showPulse(active: shouldLight)
            }
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = min(1.0, elapsed / (duration * Double(total)))
            self.timerView.setProgress(CGFloat(progress))

            if pulseIndex >= total {
                t.invalidate()
                if self.isAwaitingTap { self.handleIncorrectTapOrTimeout() }
            }
        }
        RunLoop.current.add(pulseTimer!, forMode: .common)
    }

    @objc private func iconTapped(_ sender: PulseIconView) {
        guard let question = engine.currentQuestion(), isAwaitingTap else { return }
        let isCorrectMoment = (currentPulse == question.targetPulseNumber) && (sender.index == question.targetIconIndex)
        if isCorrectMoment {
            pulseTimer?.invalidate()
            isAwaitingTap = false
            engine.advanceOnCorrect()
            scoreLabel.text = "Score: \(engine.score)"
            if engine.streak >= 3 { Toast.show(message: "Streak x\(engine.streak)!", in: view) }
            animateCorrect()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if self.engine.isCompleted { self.completeLevel() } else { self.loadNextQuestion() }
            }
        } else {
            handleIncorrectTapOrTimeout()
        }
    }

    private func handleIncorrectTapOrTimeout() {
        pulseTimer?.invalidate()
        engine.applyWrongPenalty()
        animateWrong()
        SoundManager.shared.playWrong()
        Haptic.error()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.gameOver() }
    }

    private func animateCorrect() {
        UIView.animate(withDuration: 0.2, animations: { self.view.transform = CGAffineTransform(scaleX: 1.02, y: 1.02) }) { _ in
            UIView.animate(withDuration: 0.2) { self.view.transform = .identity }
        }
        SoundManager.shared.playCorrect()
        Haptic.success()
    }

    private func animateWrong() {
        let anim = CABasicAnimation(keyPath: "position")
        anim.duration = 0.06
        anim.repeatCount = 3
        anim.autoreverses = true
        anim.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 8, y: view.center.y))
        anim.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 8, y: view.center.y))
        view.layer.add(anim, forKey: "shake")
    }

    private func completeLevel() {
        StorageManager.shared.unlockLevel(level.id + 1)
        let over = GameOverViewController(score: engine.score, level: level)
        navigationController?.pushViewController(over, animated: true)
    }

    private func gameOver() {
        let over = GameOverViewController(score: engine.score, level: level)
        navigationController?.pushViewController(over, animated: true)
    }

    override func gradientColorsForScreen() -> [UIColor] { ThemeManager.shared.gradientForScreen("Game") }
}