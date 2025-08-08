import UIKit

class GameOverViewController: BaseViewController {
    
    // MARK: - UI Elements
    private let resultCardView = UIView()
    private let titleLabel = UILabel()
    private let scoreLabel = UILabel()
    private let levelLabel = UILabel()
    private let messageLabel = UILabel()
    private let rankLabel = UILabel()
    private let buttonsStackView = UIStackView()
    
    private let playAgainButton = UIButton(type: .system)
    private let homeButton = UIButton(type: .system)
    private let leaderboardButton = UIButton(type: .system)
    
    // MARK: - Properties
    private var finalScore = 0
    private var levelId = 1
    private var levelName = ""
    private var isLevelCompleted = false
    private let gameManager = GameManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideBackButton()
        animateResults()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Game Over"
        setupResultCard()
        setupLabels()
        setupButtons()
        setupConstraints()
    }
    
    private func setupResultCard() {
        resultCardView.backgroundColor = isDarkMode() ? 
            UIColor(white: 0.1, alpha: 0.9) : 
            UIColor(white: 1.0, alpha: 0.95)
        resultCardView.layer.cornerRadius = 25
        resultCardView.layer.shadowColor = UIColor.black.cgColor
        resultCardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        resultCardView.layer.shadowOpacity = 0.3
        resultCardView.layer.shadowRadius = 15
        
        // Add subtle border
        resultCardView.layer.borderWidth = 1
        resultCardView.layer.borderColor = isDarkMode() ? 
            UIColor(white: 0.3, alpha: 0.5).cgColor : 
            UIColor(white: 0.8, alpha: 0.5).cgColor
        
        view.addSubview(resultCardView)
    }
    
    private func setupLabels() {
        // Title Label
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 32) ?? UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        resultCardView.addSubview(titleLabel)
        
        // Score Label
        scoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 48) ?? UIFont.boldSystemFont(ofSize: 48)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        resultCardView.addSubview(scoreLabel)
        
        // Level Label
        levelLabel.font = UIFont(name: "AvenirNext-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18)
        levelLabel.textAlignment = .center
        levelLabel.textColor = isDarkMode() ? UIColor(white: 0.7, alpha: 1.0) : UIColor(white: 0.5, alpha: 1.0)
        resultCardView.addSubview(levelLabel)
        
        // Message Label
        messageLabel.font = UIFont(name: "AvenirNext-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = isDarkMode() ? UIColor(white: 0.8, alpha: 1.0) : UIColor(white: 0.3, alpha: 1.0)
        resultCardView.addSubview(messageLabel)
        
        // Rank Label
        rankLabel.font = UIFont(name: "AvenirNext-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        rankLabel.textAlignment = .center
        rankLabel.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 0.8)
        rankLabel.textColor = .white
        rankLabel.layer.cornerRadius = 15
        rankLabel.clipsToBounds = true
        resultCardView.addSubview(rankLabel)
    }
    
    private func setupButtons() {
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 15
        buttonsStackView.distribution = .fillEqually
        
        // Play Again Button
        playAgainButton.setTitle("🎮 Play Again", for: .normal)
        playAgainButton.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        playAgainButton.setTitleColor(.white, for: .normal)
        playAgainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        playAgainButton.layer.cornerRadius = 25
        playAgainButton.layer.shadowColor = UIColor.black.cgColor
        playAgainButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        playAgainButton.layer.shadowOpacity = 0.3
        playAgainButton.layer.shadowRadius = 8
        playAgainButton.addTarget(self, action: #selector(playAgainTapped), for: .touchUpInside)
        
        // Home Button
        homeButton.setTitle("🏠 Home", for: .normal)
        homeButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        homeButton.setTitleColor(.white, for: .normal)
        homeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        homeButton.layer.cornerRadius = 25
        homeButton.layer.shadowColor = UIColor.black.cgColor
        homeButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        homeButton.layer.shadowOpacity = 0.3
        homeButton.layer.shadowRadius = 8
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        
        // Leaderboard Button
        leaderboardButton.setTitle("🏆 Leaderboard", for: .normal)
        leaderboardButton.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        leaderboardButton.setTitleColor(.white, for: .normal)
        leaderboardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        leaderboardButton.layer.cornerRadius = 25
        leaderboardButton.layer.shadowColor = UIColor.black.cgColor
        leaderboardButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        leaderboardButton.layer.shadowOpacity = 0.3
        leaderboardButton.layer.shadowRadius = 8
        leaderboardButton.addTarget(self, action: #selector(leaderboardTapped), for: .touchUpInside)
        
        buttonsStackView.addArrangedSubview(playAgainButton)
        buttonsStackView.addArrangedSubview(homeButton)
        buttonsStackView.addArrangedSubview(leaderboardButton)
        
        view.addSubview(buttonsStackView)
    }
    
    private func setupConstraints() {
        resultCardView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Result Card
            resultCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            resultCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            resultCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            resultCardView.heightAnchor.constraint(equalToConstant: 350),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: resultCardView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor, constant: -20),
            
            // Score Label
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            scoreLabel.centerXAnchor.constraint(equalTo: resultCardView.centerXAnchor),
            
            // Level Label
            levelLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            levelLabel.centerXAnchor.constraint(equalTo: resultCardView.centerXAnchor),
            
            // Message Label
            messageLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor, constant: -20),
            
            // Rank Label
            rankLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
            rankLabel.centerXAnchor.constraint(equalTo: resultCardView.centerXAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 200),
            rankLabel.heightAnchor.constraint(equalToConstant: 30),
            rankLabel.bottomAnchor.constraint(lessThanOrEqualTo: resultCardView.bottomAnchor, constant: -20),
            
            // Buttons Stack
            buttonsStackView.topAnchor.constraint(equalTo: resultCardView.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            // Button Heights
            playAgainButton.heightAnchor.constraint(equalToConstant: 55),
            homeButton.heightAnchor.constraint(equalToConstant: 55),
            leaderboardButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    // MARK: - Public Methods
    func setupGameOver(score: Int, level: Int, levelName: String, isCompleted: Bool) {
        self.finalScore = score
        self.levelId = level
        self.levelName = levelName
        self.isLevelCompleted = isCompleted
        
        updateContent()
    }
    
    // MARK: - Private Methods
    private func updateContent() {
        // Title
        if isLevelCompleted {
            titleLabel.text = "🎉 Level Complete!"
            titleLabel.textColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        } else {
            titleLabel.text = "💔 Game Over"
            titleLabel.textColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        }
        
        // Score
        scoreLabel.text = "\(finalScore)"
        
        // Level
        levelLabel.text = "Level \(levelId): \(levelName)"
        
        // Message
        messageLabel.text = getEncouragementMessage()
        
        // Rank
        let playerName = UserDefaults.standard.string(forKey: "playerName") ?? "Player"
        let rank = gameManager.getPlayerRank(for: playerName)
        rankLabel.text = "🎯 \(rank)"
        
        // Update card color based on completion
        if isLevelCompleted {
            resultCardView.layer.borderColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.5).cgColor
        } else {
            resultCardView.layer.borderColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5).cgColor
        }
    }
    
    private func getEncouragementMessage() -> String {
        if isLevelCompleted {
            let completedMessages = [
                "Outstanding rhythm mastery! 🎵",
                "Perfect pulse timing! ⚡",
                "You've conquered this level! 🏆",
                "Incredible focus and precision! 🎯",
                "Your timing is impeccable! ⭐"
            ]
            return completedMessages[Int.arc4random_uniform(UInt32(completedMessages.count)))]
        } else {
            if finalScore >= 100 {
                return "Great effort! So close to mastery! 💪"
            } else if finalScore >= 50 {
                return "Good try! Practice makes perfect! 🎼"
            } else {
                return "Keep practicing! You'll get the rhythm! 🌟"
            }
        }
    }
    
    private func animateResults() {
        // Initial state
        resultCardView.alpha = 0
        resultCardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        buttonsStackView.alpha = 0
        buttonsStackView.transform = CGAffineTransform(translationX: 0, y: 50)
        
        // Animate card appearance
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.resultCardView.alpha = 1
            self.resultCardView.transform = .identity
        }, completion: nil)
        
        // Animate buttons appearance
        UIView.animate(withDuration: 0.5, delay: 0.8, options: .curveEaseOut, animations: {
            self.buttonsStackView.alpha = 1
            self.buttonsStackView.transform = .identity
        }, completion: nil)
        
        // Animate score counting
        animateScoreCounting()
        
        // Add celebration effect if level completed
        if isLevelCompleted {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showCelebrationEffect()
            }
        }
    }
    
    private func animateScoreCounting() {
        let duration: TimeInterval = 1.5
        let steps = 30
        let increment = finalScore / steps
        var currentScore = 0
        
        Timer.scheduledTimer(withTimeInterval: duration / Double(steps), repeats: true) { timer in
            currentScore += increment
            
            if currentScore >= self.finalScore {
                currentScore = self.finalScore
                timer.invalidate()
            }
            
            self.scoreLabel.text = "\(currentScore)"
            
            // Add bounce effect
            UIView.animate(withDuration: 0.1) {
                self.scoreLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.scoreLabel.transform = .identity
                }
            }
        }
    }
    
    private func showCelebrationEffect() {
        // Create confetti-like effect with emoji
        let celebrationEmojis = ["🎉", "🎊", "⭐", "🌟", "💫", "✨"]
        
        for i in 0..<20 {
            let emoji = celebrationEmojis[Int.arc4random_uniform(UInt32(celebrationEmojis.count)))]
            let label = UILabel()
            label.text = emoji
            label.font = UIFont.systemFont(ofSize: 24)
            label.frame = CGRect(x: CGFloat.random(in: 0...view.frame.width), 
                               y: -50, 
                               width: 30, 
                               height: 30)
            view.addSubview(label)
            
            UIView.animate(withDuration: 3.0, delay: Double(i) * 0.1, options: .curveEaseOut, animations: {
                label.frame.origin.y = self.view.frame.height + 50
                label.alpha = 0
                label.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0...2 * .pi))
            }) { _ in
                label.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Action Methods
    @objc private func playAgainTapped() {
        // Add button animation
        animateButtonTap(playAgainButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let gameViewController = GameViewController()
            if gameViewController.setupLevel(self.levelId) {
                self.navigationController?.pushViewController(gameViewController, animated: true)
            }
        }
    }
    
    @objc private func homeTapped() {
        animateButtonTap(homeButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Navigate back to home (pop to root)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc private func leaderboardTapped() {
        animateButtonTap(leaderboardButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let leaderboardViewController = LeaderboardViewController()
            self.navigationController?.pushViewController(leaderboardViewController, animated: true)
        }
    }
    
    private func animateButtonTap(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
    }
    
    // MARK: - Override Gradient Colors
    override func getGradientColors() -> [CGColor] {
        if isLevelCompleted {
            // Success gradient
            if isDarkMode() {
                return [
                    UIColor(red: 0.0, green: 0.2, blue: 0.1, alpha: 1.0).cgColor,
                    UIColor(red: 0.1, green: 0.3, blue: 0.2, alpha: 1.0).cgColor,
                    UIColor(red: 0.2, green: 0.4, blue: 0.3, alpha: 1.0).cgColor
                ]
            } else {
                return [
                    UIColor(red: 0.9, green: 1.0, blue: 0.95, alpha: 1.0).cgColor,
                    UIColor(red: 0.8, green: 0.98, blue: 0.9, alpha: 1.0).cgColor,
                    UIColor(red: 0.7, green: 0.96, blue: 0.85, alpha: 1.0).cgColor
                ]
            }
        } else {
            // Game over gradient
            if isDarkMode() {
                return [
                    UIColor(red: 0.2, green: 0.0, blue: 0.1, alpha: 1.0).cgColor,
                    UIColor(red: 0.3, green: 0.1, blue: 0.15, alpha: 1.0).cgColor,
                    UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
                ]
            } else {
                return [
                    UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 1.0).cgColor,
                    UIColor(red: 0.98, green: 0.9, blue: 0.85, alpha: 1.0).cgColor,
                    UIColor(red: 0.96, green: 0.85, blue: 0.8, alpha: 1.0).cgColor
                ]
            }
        }
    }
}