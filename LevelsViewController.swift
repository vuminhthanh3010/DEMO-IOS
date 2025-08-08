import UIKit

class LevelsViewController: BaseViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let levelsStackView = UIStackView()
    
    // MARK: - Properties
    private let gameManager = GameManager.shared
    private var levels: [Level] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackButton()
        loadLevels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLevelStates()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Select Level"
        setupTitleLabel()
        setupScrollView()
        setupConstraints()
    }
    
    private func setupBackButton() {
        showCustomBackButton(action: #selector(backButtonTapped))
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Choose Your Challenge"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = isDarkMode() ? .white : UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 1.0)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)
        
        levelsStackView.axis = .vertical
        levelsStackView.spacing = 20
        levelsStackView.alignment = .fill
        levelsStackView.distribution = .equalSpacing
        contentView.addSubview(levelsStackView)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        levelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Levels Stack View
            levelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            levelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            levelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            levelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Loading
    private func loadLevels() {
        levels = gameManager.getAllLevels()
        createLevelCards()
    }
    
    private func createLevelCards() {
        // Clear existing cards
        levelsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for level in levels {
            let levelCard = createLevelCard(for: level)
            levelsStackView.addArrangedSubview(levelCard)
        }
    }
    
    private func createLevelCard(for level: Level) -> UIView {
        let cardView = UIView()
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 8
        
        let isUnlocked = gameManager.isLevelUnlocked(level.id)
        
        // Card background
        if isUnlocked {
            cardView.backgroundColor = isDarkMode() ? 
                UIColor(white: 0.15, alpha: 0.9) : 
                UIColor(white: 1.0, alpha: 0.95)
        } else {
            cardView.backgroundColor = isDarkMode() ? 
                UIColor(white: 0.1, alpha: 0.7) : 
                UIColor(white: 0.9, alpha: 0.7)
        }
        
        // Level number badge
        let levelNumberLabel = UILabel()
        levelNumberLabel.text = "\(level.id)"
        levelNumberLabel.font = UIFont.boldSystemFont(ofSize: 24)
        levelNumberLabel.textColor = .white
        levelNumberLabel.textAlignment = .center
        levelNumberLabel.backgroundColor = getDifficultyColor(level.difficulty)
        levelNumberLabel.layer.cornerRadius = 25
        levelNumberLabel.clipsToBounds = true
        cardView.addSubview(levelNumberLabel)
        
        // Level name
        let nameLabel = UILabel()
        nameLabel.text = level.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = isUnlocked ? 
            (isDarkMode() ? .white : .black) : 
            (isDarkMode() ? UIColor(white: 0.5, alpha: 1.0) : UIColor(white: 0.6, alpha: 1.0))
        cardView.addSubview(nameLabel)
        
        // Level description
        let descriptionLabel = UILabel()
        descriptionLabel.text = level.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = isUnlocked ? 
            (isDarkMode() ? UIColor(white: 0.8, alpha: 1.0) : UIColor(white: 0.4, alpha: 1.0)) : 
            (isDarkMode() ? UIColor(white: 0.4, alpha: 1.0) : UIColor(white: 0.7, alpha: 1.0))
        descriptionLabel.numberOfLines = 0
        cardView.addSubview(descriptionLabel)
        
        // Difficulty badge
        let difficultyLabel = UILabel()
        difficultyLabel.text = level.difficulty.uppercased()
        difficultyLabel.font = UIFont.boldSystemFont(ofSize: 12)
        difficultyLabel.textColor = .white
        difficultyLabel.backgroundColor = getDifficultyColor(level.difficulty)
        difficultyLabel.textAlignment = .center
        difficultyLabel.layer.cornerRadius = 10
        difficultyLabel.clipsToBounds = true
        cardView.addSubview(difficultyLabel)
        
        // Stats stack
        let statsStackView = UIStackView()
        statsStackView.axis = .horizontal
        statsStackView.spacing = 15
        statsStackView.distribution = .fillEqually
        
        let questionsLabel = createStatLabel(title: "Questions", value: "\(level.totalQuestions)")
        let timeLabel = createStatLabel(title: "Time/Q", value: "\(level.timePerQuestion)s")
        let pointsLabel = createStatLabel(title: "Points", value: "\(level.pointsPerCorrect)")
        
        statsStackView.addArrangedSubview(questionsLabel)
        statsStackView.addArrangedSubview(timeLabel)
        statsStackView.addArrangedSubview(pointsLabel)
        cardView.addSubview(statsStackView)
        
        // Lock overlay for locked levels
        if !isUnlocked {
            let lockImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
            lockImageView.tintColor = isDarkMode() ? UIColor(white: 0.6, alpha: 1.0) : UIColor(white: 0.4, alpha: 1.0)
            lockImageView.contentMode = .scaleAspectFit
            cardView.addSubview(lockImageView)
            
            lockImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                lockImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
                lockImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
                lockImageView.widthAnchor.constraint(equalToConstant: 30),
                lockImageView.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        // Setup constraints
        levelNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Level number badge
            levelNumberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            levelNumberLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            levelNumberLabel.widthAnchor.constraint(equalToConstant: 50),
            levelNumberLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // Level name
            nameLabel.leadingAnchor.constraint(equalTo: levelNumberLabel.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -60),
            
            // Description
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            // Difficulty badge
            difficultyLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            difficultyLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            difficultyLabel.widthAnchor.constraint(equalToConstant: 80),
            difficultyLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Stats stack
            statsStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            statsStackView.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 15),
            statsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            statsStackView.heightAnchor.constraint(equalToConstant: 40),
            
            // Card height
            cardView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // Add tap gesture
        if isUnlocked {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(levelCardTapped(_:)))
            cardView.addGestureRecognizer(tapGesture)
            cardView.tag = level.id
            cardView.isUserInteractionEnabled = true
        } else {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(lockedLevelTapped(_:)))
            cardView.addGestureRecognizer(tapGesture)
            cardView.isUserInteractionEnabled = true
        }
        
        return cardView
    }
    
    private func createStatLabel(title: String, value: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = isDarkMode() ? 
            UIColor(white: 0.2, alpha: 0.8) : 
            UIColor(white: 0.95, alpha: 1.0)
        containerView.layer.cornerRadius = 8
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = isDarkMode() ? UIColor(white: 0.7, alpha: 1.0) : UIColor(white: 0.5, alpha: 1.0)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.boldSystemFont(ofSize: 16)
        valueLabel.textColor = isDarkMode() ? .white : .black
        valueLabel.textAlignment = .center
        containerView.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
        ])
        
        return containerView
    }
    
    private func getDifficultyColor(_ difficulty: String) -> UIColor {
        switch difficulty.lowercased() {
        case "easy":
            return UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        case "medium":
            return UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        case "hard":
            return UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        default:
            return UIColor.gray
        }
    }
    
    private func refreshLevelStates() {
        createLevelCards() // Recreate cards to reflect unlock status
    }
    
    // MARK: - Action Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func levelCardTapped(_ gesture: UITapGestureRecognizer) {
        guard let cardView = gesture.view else { return }
        let levelId = cardView.tag
        
        // Add tap animation
        UIView.animate(withDuration: 0.1, animations: {
            cardView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                cardView.transform = .identity
            }
        }
        
        // Navigate to game
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.startLevel(levelId)
        }
    }
    
    @objc private func lockedLevelTapped(_ gesture: UITapGestureRecognizer) {
        // Show locked level alert
        let alert = UIAlertController(
            title: "Level Locked 🔒", 
            message: "Complete the previous level to unlock this challenge!", 
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func startLevel(_ levelId: Int) {
        let gameViewController = GameViewController()
        if gameViewController.setupLevel(levelId) {
            navigationController?.pushViewController(gameViewController, animated: true)
        } else {
            showErrorAlert()
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Error", 
            message: "Unable to load level data. Please try again.", 
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Override Gradient Colors
    override func getGradientColors() -> [CGColor] {
        if isDarkMode() {
            return [
                UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.15, green: 0.1, blue: 0.3, alpha: 1.0).cgColor,
                UIColor(red: 0.2, green: 0.15, blue: 0.4, alpha: 1.0).cgColor
            ]
        } else {
            return [
                UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0).cgColor,
                UIColor(red: 0.85, green: 0.9, blue: 0.98, alpha: 1.0).cgColor,
                UIColor(red: 0.8, green: 0.85, blue: 0.96, alpha: 1.0).cgColor
            ]
        }
    }
}