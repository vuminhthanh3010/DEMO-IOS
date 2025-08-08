import UIKit
import AVFoundation
import AudioToolbox

class GameViewController: BaseViewController {
    
    // MARK: - UI Elements
    private let scoreLabel = UILabel()
    private let timeProgressView = UIProgressView()
    private let questionLabel = UILabel()
    private let instructionLabel = UILabel()
    private let iconsContainerView = UIView()
    private let controlsStackView = UIStackView()
    
    private let pauseButton = UIButton(type: .system)
    private let skipButton = UIButton(type: .system)
    
    private var iconButtons: [UIButton] = []
    private var currentPulseIndex = 0
    private var isPaused = false
    private var isGameActive = false
    private var currentPulseStep = 0
    
    // MARK: - Game Properties
    private let gameManager = GameManager.shared
    private var currentLevel: Level?
    private var currentQuestion: Question?
    private var gameTimer: Timer?
    private var pulseTimer: Timer?
    private var streakCount = 0
    
    // MARK: - Audio
    private var correctSoundPlayer: AVAudioPlayer?
    private var wrongSoundPlayer: AVAudioPlayer?
    private var pulseSoundPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudio()
        hideBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isGameActive {
            startGame()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseGame()
    }
    
    deinit {
        gameTimer?.invalidate()
        pulseTimer?.invalidate()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Pulse Tap"
        setupScoreLabel()
        setupTimeProgress()
        setupQuestionLabel()
        setupInstructionLabel()
        setupIconsContainer()
        setupControlButtons()
        setupConstraints()
    }
    
    private func setupScoreLabel() {
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        scoreLabel.textColor = isDarkMode() ? .white : .black
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)
    }
    
    private func setupTimeProgress() {
        timeProgressView.progressTintColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        timeProgressView.trackTintColor = isDarkMode() ? 
            UIColor(white: 0.3, alpha: 1.0) : 
            UIColor(white: 0.8, alpha: 1.0)
        timeProgressView.layer.cornerRadius = 8
        timeProgressView.clipsToBounds = true
        timeProgressView.transform = CGAffineTransform(scaleX: 1, y: 3)
        view.addSubview(timeProgressView)
    }
    
    private func setupQuestionLabel() {
        questionLabel.text = "Question 1/5"
        questionLabel.font = UIFont.systemFont(ofSize: 16)
        questionLabel.textColor = isDarkMode() ? UIColor(white: 0.8, alpha: 1.0) : UIColor(white: 0.4, alpha: 1.0)
        questionLabel.textAlignment = .center
        view.addSubview(questionLabel)
    }
    
    private func setupInstructionLabel() {
        instructionLabel.text = "Get ready..."
        instructionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        instructionLabel.textColor = isDarkMode() ? .white : .black
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        view.addSubview(instructionLabel)
    }
    
    private func setupIconsContainer() {
        iconsContainerView.backgroundColor = .clear
        view.addSubview(iconsContainerView)
        
        createIconButtons()
    }
    
    private func createIconButtons() {
        iconButtons.removeAll()
        iconsContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        let iconCount = gameManager.getTotalIcons()
        let iconTypes = gameManager.getIconTypes()
        
        for i in 1...iconCount {
            let button = UIButton(type: .custom)
            button.tag = i
            button.backgroundColor = isDarkMode() ? 
                UIColor(white: 0.2, alpha: 0.8) : 
                UIColor(white: 0.9, alpha: 0.8)
            button.layer.cornerRadius = 30
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.3
            button.layer.shadowRadius = 4
            
            // Set icon text based on type
            let iconType = iconTypes[(i-1) % iconTypes.count]
            let iconText = getIconText(for: iconType)
            button.setTitle(iconText, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            button.setTitleColor(isDarkMode() ? .white : .black, for: .normal)
            
            button.addTarget(self, action: #selector(iconTapped(_:)), for: .touchUpInside)
            
            iconsContainerView.addSubview(button)
            iconButtons.append(button)
        }
        
        layoutIconButtons()
    }
    
    private func layoutIconButtons() {
        guard !iconButtons.isEmpty else { return }
        
        iconButtons.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let buttonSize: CGFloat = 60
        let spacing: CGFloat = 20
        let totalWidth = CGFloat(iconButtons.count) * buttonSize + CGFloat(iconButtons.count - 1) * spacing
        
        for (index, button) in iconButtons.enumerated() {
            let xOffset = CGFloat(index) * (buttonSize + spacing) - totalWidth / 2 + buttonSize / 2
            
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: iconsContainerView.centerXAnchor, constant: xOffset),
                button.centerYAnchor.constraint(equalTo: iconsContainerView.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: buttonSize),
                button.heightAnchor.constraint(equalToConstant: buttonSize)
            ])
        }
    }
    
    private func getIconText(for type: String) -> String {
        switch type.lowercased() {
        case "circle": return "●"
        case "star": return "⭐"
        case "heart": return "❤️"
        case "diamond": return "💎"
        case "triangle": return "▲"
        default: return "●"
        }
    }
    
    private func setupControlButtons() {
        controlsStackView.axis = .horizontal
        controlsStackView.spacing = 20
        controlsStackView.distribution = .fillEqually
        
        // Pause Button
        pauseButton.setTitle("⏸️ Pause", for: .normal)
        pauseButton.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        pauseButton.layer.cornerRadius = 20
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        
        // Skip Button
        skipButton.setTitle("⏭️ Skip (-10)", for: .normal)
        skipButton.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        skipButton.layer.cornerRadius = 20
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        
        controlsStackView.addArrangedSubview(pauseButton)
        controlsStackView.addArrangedSubview(skipButton)
        
        view.addSubview(controlsStackView)
    }
    
    private func setupConstraints() {
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        timeProgressView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        iconsContainerView.translatesAutoresizingMaskIntoConstraints = false
        controlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Score Label
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Time Progress
            timeProgressView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 15),
            timeProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            timeProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            timeProgressView.heightAnchor.constraint(equalToConstant: 8),
            
            // Question Label
            questionLabel.topAnchor.constraint(equalTo: timeProgressView.bottomAnchor, constant: 20),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Instruction Label
            instructionLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Icons Container
            iconsContainerView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 40),
            iconsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iconsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iconsContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            // Controls Stack
            controlsStackView.topAnchor.constraint(equalTo: iconsContainerView.bottomAnchor, constant: 60),
            controlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            controlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            controlsStackView.heightAnchor.constraint(equalToConstant: 50),
            controlsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupAudio() {
        // Setup audio players for sound effects
        setupSoundEffect(named: "correct_sound", player: &correctSoundPlayer)
        setupSoundEffect(named: "wrong_sound", player: &wrongSoundPlayer)
        setupSoundEffect(named: "pulse_sound", player: &pulseSoundPlayer)
    }
    
    private func setupSoundEffect(named soundName: String, player: inout AVAudioPlayer?) {
        // For now, we'll use system sounds. In a real app, you'd add actual sound files
        // This is a placeholder for sound setup
    }
    
    // MARK: - Game Setup
    func setupLevel(_ levelId: Int) -> Bool {
        return gameManager.startLevel(levelId)
    }
    
    private func startGame() {
        currentLevel = gameManager.getCurrentLevel()
        loadNextQuestion()
        isGameActive = true
        startGameTimer()
    }
    
    private func loadNextQuestion() {
        currentQuestion = gameManager.getCurrentQuestion()
        
        guard let question = currentQuestion else {
            // Level completed
            gameCompleted()
            return
        }
        
        updateUI()
        resetPulseAnimation()
        
        // Print answer to console for debugging
        print("🎯 ANSWER: Tap icon \(question.targetIcon) at pulse \(question.targetPulse)")
        
        // Start pulse sequence after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startPulseSequence()
        }
    }
    
    private func updateUI() {
        guard let question = currentQuestion else { return }
        
        let currentIndex = gameManager.getCurrentQuestionIndex() + 1
        let totalQuestions = gameManager.getTotalQuestions()
        
        scoreLabel.text = "Score: \(gameManager.getCurrentScore())"
        questionLabel.text = "Question \(currentIndex)/\(totalQuestions)"
        instructionLabel.text = question.instruction
        
        updateTimeProgress()
    }
    
    private func updateTimeProgress() {
        guard let level = currentLevel else { return }
        let currentTime = gameManager.getCurrentTime()
        let totalTime = level.timePerQuestion
        let progress = Float(currentTime) / Float(totalTime)
        
        UIView.animate(withDuration: 0.3) {
            self.timeProgressView.progress = progress
        }
        
        // Change color based on time remaining
        if progress < 0.3 {
            timeProgressView.progressTintColor = UIColor.red
        } else if progress < 0.6 {
            timeProgressView.progressTintColor = UIColor.orange
        } else {
            timeProgressView.progressTintColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        }
    }
    
    // MARK: - Pulse Animation
    private func startPulseSequence() {
        guard let question = currentQuestion, let level = currentLevel else { return }
        
        currentPulseStep = 0
        
        pulseTimer = Timer.scheduledTimer(withTimeInterval: level.pulseSpeed, repeats: true) { _ in
            self.executePulseStep()
        }
    }
    
    private func executePulseStep() {
        guard let question = currentQuestion else { return }
        
        currentPulseStep += 1
        
        // Find the pulse pattern for current step
        if let pulsePattern = question.pulsePattern.first(where: { $0.pulse == currentPulseStep }) {
            animateIconsPulse(lightedIcons: pulsePattern.lightedIcons)
            playPulseSound()
        }
        
        // Check for fake icons
        let fakeIcons = question.fakeIcons.filter { $0.pulse == currentPulseStep }
        for fakeIcon in fakeIcons {
            animateFakeIcon(iconIndex: fakeIcon.icon)
        }
        
        // Reset after all pulses
        if currentPulseStep >= (question.pulsePattern.last?.pulse ?? 4) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.currentPulseStep = 0
            }
        }
    }
    
    private func animateIconsPulse(lightedIcons: [Int]) {
        // Reset all icons to normal state
        resetIconsToNormalState()
        
        // Animate selected icons
        for iconIndex in lightedIcons {
            if iconIndex > 0 && iconIndex <= iconButtons.count {
                let button = iconButtons[iconIndex - 1]
                animateIconHighlight(button)
            }
        }
    }
    
    private func animateFakeIcon(iconIndex: Int) {
        if iconIndex > 0 && iconIndex <= iconButtons.count {
            let button = iconButtons[iconIndex - 1]
            animateIconFake(button)
        }
    }
    
    private func resetIconsToNormalState() {
        for button in iconButtons {
            UIView.animate(withDuration: 0.2) {
                button.backgroundColor = self.isDarkMode() ? 
                    UIColor(white: 0.2, alpha: 0.8) : 
                    UIColor(white: 0.9, alpha: 0.8)
                button.transform = .identity
            }
        }
    }
    
    private func animateIconHighlight(_ button: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            button.backgroundColor = UIColor(red: 0.9, green: 0.8, blue: 0.2, alpha: 1.0)
            button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                button.transform = .identity
            }
        }
    }
    
    private func animateIconFake(_ button: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            button.backgroundColor = UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 0.8)
            button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                button.transform = .identity
            }
        }
    }
    
    private func resetPulseAnimation() {
        pulseTimer?.invalidate()
        currentPulseStep = 0
        resetIconsToNormalState()
    }
    
    // MARK: - Game Timer
    private func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if !self.isPaused {
                self.gameManager.updateTime()
                self.updateTimeProgress()
                
                if self.gameManager.isTimeUp() {
                    self.timeUp()
                }
            }
        }
    }
    
    private func timeUp() {
        // Time's up - treat as wrong answer
        handleWrongAnswer()
    }
    
    // MARK: - Action Methods
    @objc private func iconTapped(_ sender: UIButton) {
        let iconIndex = sender.tag
        let currentPulse = currentPulseStep
        
        // Animate tap feedback
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
        
        // Check answer
        let isCorrect = gameManager.checkAnswer(iconTapped: iconIndex, pulseTapped: currentPulse)
        
        if isCorrect {
            handleCorrectAnswer(sender)
        } else {
            handleWrongAnswer()
        }
    }
    
    @objc private func pauseButtonTapped() {
        if isPaused {
            resumeGame()
        } else {
            pauseGame()
        }
    }
    
    @objc private func skipButtonTapped() {
        gameManager.skipQuestion()
        updateUI()
        
        if !gameManager.nextQuestion() {
            gameCompleted()
        } else {
            loadNextQuestion()
        }
    }
    
    // MARK: - Game Logic
    private func handleCorrectAnswer(_ button: UIButton) {
        streakCount += 1
        
        // Animate correct feedback
        animateCorrectFeedback(button)
        playCorrectSound()
        
        // Show streak notification
        if streakCount >= 3 {
            showStreakNotification()
        }
        
        // Move to next question
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !self.gameManager.nextQuestion() {
                self.gameCompleted()
            } else {
                self.loadNextQuestion()
            }
        }
    }
    
    private func handleWrongAnswer() {
        streakCount = 0
        
        // Animate wrong feedback
        animateWrongFeedback()
        playWrongSound()
        
        // Game over
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameOver()
        }
    }
    
    private func animateCorrectFeedback(_ button: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            button.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
            button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                button.transform = .identity
            }
        }
    }
    
    private func animateWrongFeedback() {
        // Shake animation for wrong answer
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        view.layer.add(animation, forKey: "shake")
        
        // Flash red background
        let originalBackgroundColor = view.backgroundColor
        UIView.animate(withDuration: 0.1, animations: {
            self.view.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.view.backgroundColor = originalBackgroundColor
            }
        }
    }
    
    private func showStreakNotification() {
        let messages = [
            "🔥 On Fire! 3 in a row!",
            "⚡ Lightning Fast! Keep it up!",
            "🎯 Perfect Rhythm! Amazing!",
            "🌟 Streak Master! Incredible!"
        ]
        
        let message = messages[Int.arc4random_uniform(UInt32(messages.count))]
        
        let alert = UIAlertController(title: "Streak Bonus!", message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
    
    private func pauseGame() {
        isPaused = true
        pulseTimer?.invalidate()
        pauseButton.setTitle("▶️ Resume", for: .normal)
        
        let alert = UIAlertController(title: "Game Paused", message: "Take your time!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Resume", style: .default) { _ in
            self.resumeGame()
        })
        present(alert, animated: true)
    }
    
    private func resumeGame() {
        isPaused = false
        pauseButton.setTitle("⏸️ Pause", for: .normal)
        startPulseSequence()
    }
    
    private func gameCompleted() {
        gameTimer?.invalidate()
        pulseTimer?.invalidate()
        isGameActive = false
        
        let gameOverVC = GameOverViewController()
        gameOverVC.setupGameOver(
            score: gameManager.getCurrentScore(),
            level: currentLevel?.id ?? 1,
            levelName: currentLevel?.name ?? "Unknown",
            isCompleted: true
        )
        navigationController?.pushViewController(gameOverVC, animated: true)
    }
    
    private func gameOver() {
        gameTimer?.invalidate()
        pulseTimer?.invalidate()
        isGameActive = false
        
        let gameOverVC = GameOverViewController()
        gameOverVC.setupGameOver(
            score: gameManager.getCurrentScore(),
            level: currentLevel?.id ?? 1,
            levelName: currentLevel?.name ?? "Unknown",
            isCompleted: false
        )
        navigationController?.pushViewController(gameOverVC, animated: true)
    }
    
    // MARK: - Audio Methods
    private func playCorrectSound() {
        // Placeholder for correct sound
        AudioServicesPlaySystemSound(1057) // System sound for correct
    }
    
    private func playWrongSound() {
        // Placeholder for wrong sound
        AudioServicesPlaySystemSound(1053) // System sound for wrong
    }
    
    private func playPulseSound() {
        // Placeholder for pulse sound
        AudioServicesPlaySystemSound(1104) // System sound for pulse
    }
    
    // MARK: - Override Gradient Colors
    override func getGradientColors() -> [CGColor] {
        if isDarkMode() {
            return [
                UIColor(red: 0.05, green: 0.0, blue: 0.15, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.15, green: 0.1, blue: 0.25, alpha: 1.0).cgColor
            ]
        } else {
            return [
                UIColor(red: 0.95, green: 0.98, blue: 1.0, alpha: 1.0).cgColor,
                UIColor(red: 0.9, green: 0.96, blue: 0.99, alpha: 1.0).cgColor,
                UIColor(red: 0.85, green: 0.94, blue: 0.98, alpha: 1.0).cgColor
            ]
        }
    }
}