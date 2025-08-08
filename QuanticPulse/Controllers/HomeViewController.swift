import UIKit
import StoreKit

final class HomeViewController: BaseViewController {
    private let welcomeLabel = UILabel()
    private let nameField = UITextField()
    private let tipLabel = UILabel()
    private let clockLabel = UILabel()
    private let playButton = UIButton(type: .system)
    private let tutorialButton = UIButton(type: .system)
    private let leaderboardButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private var clockTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationItem.hidesBackButton = true

        welcomeLabel.textColor = ThemeManager.shared.primaryTextColor
        welcomeLabel.font = .systemFont(ofSize: 28, weight: .bold)
        welcomeLabel.textAlignment = .left

        nameField.text = SettingsManager.shared.playerName
        nameField.placeholder = "Enter name"
        nameField.borderStyle = .roundedRect
        nameField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        nameField.textColor = ThemeManager.shared.primaryTextColor
        nameField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)

        tipLabel.text = "Tip: Skip wisely to save time, but you will lose some points!"
        tipLabel.textColor = ThemeManager.shared.secondaryTextColor
        tipLabel.numberOfLines = 0

        clockLabel.textColor = ThemeManager.shared.secondaryTextColor
        clockLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)

        [playButton, tutorialButton, leaderboardButton, settingsButton].forEach { btn in
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            btn.backgroundColor = ThemeManager.shared.currentTintColor.withAlphaComponent(0.9)
            btn.layer.cornerRadius = 14
            btn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        }
        playButton.setTitle("Play", for: .normal)
        tutorialButton.setTitle("Tutorial", for: .normal)
        leaderboardButton.setTitle("Leaderboard", for: .normal)
        settingsButton.setTitle("Settings", for: .normal)

        playButton.addTarget(self, action: #selector(goPlay), for: .touchUpInside)
        tutorialButton.addTarget(self, action: #selector(goTutorial), for: .touchUpInside)
        leaderboardButton.addTarget(self, action: #selector(goLeaderboard), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(goSettings), for: .touchUpInside)

        let headerStack = UIStackView(arrangedSubviews: [welcomeLabel, nameField, tipLabel, clockLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 10

        let grid = UIStackView(arrangedSubviews: [playButton, tutorialButton, leaderboardButton, settingsButton])
        grid.axis = .vertical
        grid.spacing = 14

        let container = UIStackView(arrangedSubviews: [headerStack, grid])
        container.axis = .vertical
        container.spacing = 24

        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        updateWelcome()
        startClock()
    }

    private func startClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d • HH:mm:ss"
        clockTimer?.invalidate()
        clockTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.clockLabel.text = formatter.string(from: Date())
        }
        clockTimer?.tolerance = 0.1
        RunLoop.current.add(clockTimer!, forMode: .common)
    }

    deinit { clockTimer?.invalidate() }

    private func updateWelcome() {
        welcomeLabel.text = "Hello, \(SettingsManager.shared.playerName)!"
    }

    @objc private func nameChanged() {
        SettingsManager.shared.playerName = nameField.text ?? "Player"
        updateWelcome()
    }

    @objc private func goPlay() { navigationController?.pushViewController(LevelsViewController(), animated: true) }
    @objc private func goTutorial() { navigationController?.pushViewController(TutorialViewController(), animated: true) }
    @objc private func goLeaderboard() { navigationController?.pushViewController(LeaderboardViewController(), animated: true) }
    @objc private func goSettings() { navigationController?.pushViewController(SettingsViewController(), animated: true) }

    override func gradientColorsForScreen() -> [UIColor] { ThemeManager.shared.gradientForScreen("Home") }
}