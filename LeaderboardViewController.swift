import UIKit

class LeaderboardViewController: BaseViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let emptyStateView = UIView()
    private let emptyStateLabel = UILabel()
    
    // MARK: - Properties
    private let gameManager = GameManager.shared
    private var scores: [ScoreEntry] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackButton()
        loadScores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshScores()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Leaderboard"
        setupTitleLabel()
        setupTableView()
        setupEmptyState()
        setupConstraints()
    }
    
    private func setupBackButton() {
        showCustomBackButton(action: #selector(backButtonTapped))
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "🏆 Hall of Fame"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 28) ?? UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = isDarkMode() ? .white : UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 1.0)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
        view.addSubview(tableView)
    }
    
    private func setupEmptyState() {
        emptyStateView.backgroundColor = .clear
        emptyStateView.isHidden = true
        
        emptyStateLabel.text = "🎮\n\nNo scores yet!\nStart playing to see your rankings here."
        emptyStateLabel.font = UIFont.systemFont(ofSize: 18)
        emptyStateLabel.textColor = isDarkMode() ? UIColor(white: 0.6, alpha: 1.0) : UIColor(white: 0.4, alpha: 1.0)
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        
        emptyStateView.addSubview(emptyStateLabel)
        view.addSubview(emptyStateView)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Empty State
            emptyStateView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: emptyStateView.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: emptyStateView.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Data Methods
    private func loadScores() {
        scores = gameManager.getHighScores()
        updateUI()
    }
    
    private func refreshScores() {
        loadScores()
        tableView.reloadData()
    }
    
    private func updateUI() {
        let hasScores = !scores.isEmpty
        tableView.isHidden = !hasScores
        emptyStateView.isHidden = hasScores
    }
    
    // MARK: - Action Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Override Gradient Colors
    override func getGradientColors() -> [CGColor] {
        if isDarkMode() {
            return [
                UIColor(red: 0.1, green: 0.05, blue: 0.0, alpha: 1.0).cgColor,
                UIColor(red: 0.2, green: 0.1, blue: 0.05, alpha: 1.0).cgColor,
                UIColor(red: 0.3, green: 0.15, blue: 0.1, alpha: 1.0).cgColor
            ]
        } else {
            return [
                UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0).cgColor,
                UIColor(red: 0.98, green: 0.95, blue: 0.85, alpha: 1.0).cgColor,
                UIColor(red: 0.96, green: 0.92, blue: 0.8, alpha: 1.0).cgColor
            ]
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let score = scores[indexPath.row]
        let rank = indexPath.row + 1
        cell.configure(with: score, rank: rank, isDarkMode: isDarkMode())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Leaderboard Cell
class LeaderboardCell: UITableViewCell {
    
    private let containerView = UIView()
    private let rankLabel = UILabel()
    private let playerNameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let levelLabel = UILabel()
    private let dateLabel = UILabel()
    private let medalImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)
        
        rankLabel.font = UIFont.boldSystemFont(ofSize: 24)
        rankLabel.textAlignment = .center
        containerView.addSubview(rankLabel)
        
        medalImageView.contentMode = .scaleAspectFit
        containerView.addSubview(medalImageView)
        
        playerNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        containerView.addSubview(playerNameLabel)
        
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        scoreLabel.textAlignment = .right
        containerView.addSubview(scoreLabel)
        
        levelLabel.font = UIFont.systemFont(ofSize: 14)
        levelLabel.textAlignment = .right
        containerView.addSubview(levelLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textAlignment = .right
        containerView.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        medalImageView.translatesAutoresizingMaskIntoConstraints = false
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            rankLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            rankLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 40),
            
            medalImageView.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 5),
            medalImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            medalImageView.widthAnchor.constraint(equalToConstant: 30),
            medalImageView.heightAnchor.constraint(equalToConstant: 30),
            
            playerNameLabel.leadingAnchor.constraint(equalTo: medalImageView.trailingAnchor, constant: 10),
            playerNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            playerNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: scoreLabel.leadingAnchor, constant: -10),
            
            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            scoreLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            scoreLabel.widthAnchor.constraint(equalToConstant: 80),
            
            levelLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            levelLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 2),
            levelLabel.widthAnchor.constraint(equalToConstant: 80),
            
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            dateLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(with score: ScoreEntry, rank: Int, isDarkMode: Bool) {
        // Container styling
        containerView.backgroundColor = isDarkMode ? 
            UIColor(white: 0.15, alpha: 0.9) : 
            UIColor(white: 1.0, alpha: 0.95)
        
        // Rank styling
        rankLabel.text = "\(rank)"
        if rank <= 3 {
            rankLabel.textColor = getRankColor(rank)
            medalImageView.isHidden = false
            medalImageView.text = getRankMedal(rank)
        } else {
            rankLabel.textColor = isDarkMode ? .white : .black
            medalImageView.isHidden = true
        }
        
        // Player name
        playerNameLabel.text = score.playerName
        playerNameLabel.textColor = isDarkMode ? .white : .black
        
        // Score
        scoreLabel.text = "\(score.score)"
        scoreLabel.textColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        
        // Level
        levelLabel.text = "Level \(score.level)"
        levelLabel.textColor = isDarkMode ? UIColor(white: 0.7, alpha: 1.0) : UIColor(white: 0.5, alpha: 1.0)
        
        // Date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateLabel.text = formatter.string(from: score.date)
        dateLabel.textColor = isDarkMode ? UIColor(white: 0.6, alpha: 1.0) : UIColor(white: 0.6, alpha: 1.0)
        
        // Special styling for top ranks
        if rank <= 3 {
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = getRankColor(rank).cgColor
        } else {
            containerView.layer.borderWidth = 0
        }
    }
    
    private func getRankColor(_ rank: Int) -> UIColor {
        switch rank {
        case 1: return UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) // Gold
        case 2: return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) // Silver
        case 3: return UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0) // Bronze
        default: return .gray
        }
    }
    
    private func getRankMedal(_ rank: Int) -> String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return ""
        }
    }
}

// Extension to add text to UIImageView for medals
extension UIImageView {
    var text: String? {
        get { return nil }
        set {
            let label = UILabel(frame: bounds)
            label.text = newValue
            label.font = UIFont.systemFont(ofSize: 20)
            label.textAlignment = .center
            addSubview(label)
        }
    }
}