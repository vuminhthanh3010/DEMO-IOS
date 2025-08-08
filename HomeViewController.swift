import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - UI Elements
    private let welcomeLabel = UILabel()
    private let playerNameLabel = UILabel()
    private let weatherInfoLabel = UILabel()
    private let tipLabel = UILabel()
    private let buttonsStackView = UIStackView()
    
    private let playButton = UIButton(type: .system)
    private let tutorialButton = UIButton(type: .system)
    private let leaderboardButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let dailyChallengeButton = UIButton(type: .system)
    private let achievementsButton = UIButton(type: .system)
    
    // MARK: - Properties
    private var playerName: String {
        get {
            return UserDefaults.standard.string(forKey: "playerName") ?? "Pulse Master"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "playerName")
            updatePlayerNameLabel()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideBackButton()
        loadPlayerData()
        setupWeatherInfo()
        setupDailyTip()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePlayerStats()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupWelcomeLabel()
        setupPlayerNameLabel()
        setupWeatherInfoLabel()
        setupTipLabel()
        setupButtons()
        setupStackView()
        setupConstraints()
    }
    
    private func setupWelcomeLabel() {
        welcomeLabel.text = "Welcome Back!"
        welcomeLabel.font = UIFont(name: "AvenirNext-Bold", size: 28) ?? UIFont.boldSystemFont(ofSize: 28)
        welcomeLabel.textColor = isDarkMode() ? .white : UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 1.0)
        welcomeLabel.textAlignment = .center
        view.addSubview(welcomeLabel)
    }
    
    private func setupPlayerNameLabel() {
        playerNameLabel.font = UIFont(name: "AvenirNext-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18)
        playerNameLabel.textColor = isDarkMode() ? UIColor(white: 0.8, alpha: 1.0) : UIColor(red: 0.4, green: 0.5, blue: 0.7, alpha: 1.0)
        playerNameLabel.textAlignment = .center
        playerNameLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editPlayerName))
        playerNameLabel.addGestureRecognizer(tapGesture)
        
        view.addSubview(playerNameLabel)
    }
    
    private func setupWeatherInfoLabel() {
        weatherInfoLabel.font = UIFont.systemFont(ofSize: 14)
        weatherInfoLabel.textColor = isDarkMode() ? UIColor(white: 0.7, alpha: 1.0) : UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
        weatherInfoLabel.textAlignment = .center
        weatherInfoLabel.numberOfLines = 0
        view.addSubview(weatherInfoLabel)
    }
    
    private func setupTipLabel() {
        tipLabel.font = UIFont.italicSystemFont(ofSize: 16)
        tipLabel.textColor = isDarkMode() ? UIColor(white: 0.8, alpha: 1.0) : UIColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 1.0)
        tipLabel.textAlignment = .center
        tipLabel.numberOfLines = 0
        view.addSubview(tipLabel)
    }
    
    private func setupButtons() {
        // Play Button
        playButton.setTitle("🎮 Start Playing", for: .normal)
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        playButton.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        playButton.setTitleColor(.white, for: .normal)
        playButton.layer.cornerRadius = 25
        playButton.layer.shadowColor = UIColor.black.cgColor
        playButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        playButton.layer.shadowOpacity = 0.3
        playButton.layer.shadowRadius = 8
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        // Tutorial Button
        tutorialButton.setTitle("📖 How to Play", for: .normal)
        tutorialButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        tutorialButton.setTitleColor(.white, for: .normal)
        tutorialButton.addTarget(self, action: #selector(tutorialButtonTapped), for: .touchUpInside)
        
        // Leaderboard Button
        leaderboardButton.setTitle("🏆 Leaderboard", for: .normal)
        leaderboardButton.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        leaderboardButton.setTitleColor(.white, for: .normal)
        leaderboardButton.addTarget(self, action: #selector(leaderboardButtonTapped), for: .touchUpInside)
        
        // Settings Button
        settingsButton.setTitle("⚙️ Settings", for: .normal)
        settingsButton.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        // Daily Challenge Button
        dailyChallengeButton.setTitle("⭐ Daily Challenge", for: .normal)
        dailyChallengeButton.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.8, alpha: 1.0)
        dailyChallengeButton.setTitleColor(.white, for: .normal)
        dailyChallengeButton.addTarget(self, action: #selector(dailyChallengeButtonTapped), for: .touchUpInside)
        
        // Achievements Button
        achievementsButton.setTitle("🎯 Achievements", for: .normal)
        achievementsButton.backgroundColor = UIColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 1.0)
        achievementsButton.setTitleColor(.white, for: .normal)
        achievementsButton.addTarget(self, action: #selector(achievementsButtonTapped), for: .touchUpInside)
        
        // Style all buttons
        let allButtons = [tutorialButton, leaderboardButton, settingsButton, dailyChallengeButton, achievementsButton]
        for button in allButtons {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 20
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.3
            button.layer.shadowRadius = 4
        }
    }
    
    private func setupStackView() {
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 15
        buttonsStackView.distribution = .fillEqually
        
        buttonsStackView.addArrangedSubview(playButton)
        
        // Create horizontal stack for secondary buttons
        let topRowStack = UIStackView(arrangedSubviews: [tutorialButton, leaderboardButton])
        topRowStack.axis = .horizontal
        topRowStack.spacing = 15
        topRowStack.distribution = .fillEqually
        
        let middleRowStack = UIStackView(arrangedSubviews: [dailyChallengeButton, achievementsButton])
        middleRowStack.axis = .horizontal
        middleRowStack.spacing = 15
        middleRowStack.distribution = .fillEqually
        
        buttonsStackView.addArrangedSubview(topRowStack)
        buttonsStackView.addArrangedSubview(middleRowStack)
        buttonsStackView.addArrangedSubview(settingsButton)
        
        view.addSubview(buttonsStackView)
    }
    
    private func setupConstraints() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // Player Name Label
            playerNameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            playerNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            playerNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // Weather Info Label
            weatherInfoLabel.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 20),
            weatherInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherInfoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            weatherInfoLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // Tip Label
            tipLabel.topAnchor.constraint(equalTo: weatherInfoLabel.bottomAnchor, constant: 15),
            tipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tipLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            tipLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // Buttons Stack View
            buttonsStackView.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            // Play Button Height
            playButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Other Buttons Height
            tutorialButton.heightAnchor.constraint(equalToConstant: 50),
            leaderboardButton.heightAnchor.constraint(equalToConstant: 50),
            dailyChallengeButton.heightAnchor.constraint(equalToConstant: 50),
            achievementsButton.heightAnchor.constraint(equalToConstant: 50),
            settingsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Data Methods
    private func loadPlayerData() {
        updatePlayerNameLabel()
    }
    
    private func updatePlayerNameLabel() {
        playerNameLabel.text = "👋 \(playerName) (Tap to edit)"
    }
    
    private func updatePlayerStats() {
        let totalScore = UserDefaults.standard.integer(forKey: "totalScore")
        let gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")
        
        if gamesPlayed > 0 {
            weatherInfoLabel.text = "🎯 Total Score: \(totalScore) | Games Played: \(gamesPlayed)"
        }
    }
    
    private func setupWeatherInfo() {
        // Simulate weather info
        let weatherEmojis = ["☀️", "⛅", "🌤️", "🌈", "❄️"]
        let weatherDescriptions = ["Sunny", "Partly Cloudy", "Bright", "Rainbow", "Cool"]
        let randomIndex = Int.arc4random_uniform(UInt32(weatherEmojis.count)))
        
        weatherInfoLabel.text = "\(weatherEmojis[randomIndex]) Today: \(weatherDescriptions[randomIndex]) - Perfect for Pulse Tapping!"
    }
    
    private func setupDailyTip() {
        let tips = [
            "💡 Tip: Focus on the rhythm, not just the icons!",
            "🎵 Tip: Try to feel the beat in your mind",
            "⚡ Tip: Quick reactions lead to higher scores",
            "🎯 Tip: Watch for fake pulse patterns",
            "🧠 Tip: Practice makes perfect rhythm master!"
        ]
        
        let randomTip = tips[Int.arc4random_uniform(UInt32(tips.count)))]
        tipLabel.text = randomTip
    }
    
    // MARK: - Action Methods
    @objc private func playButtonTapped() {
        let levelsViewController = LevelsViewController()
        navigationController?.pushViewController(levelsViewController, animated: true)
    }
    
    @objc private func tutorialButtonTapped() {
        let tutorialViewController = TutorialViewController()
        navigationController?.pushViewController(tutorialViewController, animated: true)
    }
    
    @objc private func leaderboardButtonTapped() {
        let leaderboardViewController = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardViewController, animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @objc private func dailyChallengeButtonTapped() {
        showComingSoonAlert(feature: "Daily Challenge")
    }
    
    @objc private func achievementsButtonTapped() {
        showComingSoonAlert(feature: "Achievements")
    }
    
    @objc private func editPlayerName() {
        let alert = UIAlertController(title: "Edit Player Name", message: "Enter your new name:", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = self.playerName
            textField.placeholder = "Enter your name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let newName = alert.textFields?.first?.text, !newName.isEmpty {
                self.playerName = newName
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showComingSoonAlert(feature: String) {
        let alert = UIAlertController(title: "Coming Soon!", message: "\(feature) feature will be available in future updates. Stay tuned!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Override Gradient Colors
    override func getGradientColors() -> [CGColor] {
        if isDarkMode() {
            return [
                UIColor(red: 0.05, green: 0.1, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0).cgColor,
                UIColor(red: 0.15, green: 0.25, blue: 0.4, alpha: 1.0).cgColor
            ]
        } else {
            return [
                UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0).cgColor,
                UIColor(red: 0.9, green: 0.95, blue: 0.98, alpha: 1.0).cgColor,
                UIColor(red: 0.85, green: 0.92, blue: 0.96, alpha: 1.0).cgColor
            ]
        }
    }
}