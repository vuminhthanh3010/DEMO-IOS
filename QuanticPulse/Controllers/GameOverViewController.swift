import UIKit

final class GameOverViewController: BaseViewController {
    private let score: Int
    private let level: Level

    init(score: Int, level: Level) {
        self.score = score
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = "Game Over"

        let entry = LeaderboardEntry(playerName: SettingsManager.shared.playerName, score: score, levelId: level.id, date: Date())
        var entries = StorageManager.shared.loadLeaderboard()
        entries.append(entry)
        StorageManager.shared.saveLeaderboard(entries: entries)

        let titleLabel = UILabel()
        titleLabel.text = "Game Over"
        titleLabel.font = .systemFont(ofSize: 34, weight: .heavy)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white

        let card = UIView()
        card.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        card.layer.cornerRadius = 16
        let scoreLabel = UILabel()
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = .monospacedDigitSystemFont(ofSize: 24, weight: .bold)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .white
        let levelLabel = UILabel()
        levelLabel.text = "Level: \(level.name)"
        levelLabel.textColor = .white
        levelLabel.textAlignment = .center

        let message = UILabel()
        message.text = score > 0 ? "Great job! Keep the rhythm going!" : "Don't give up! Try again to unlock more."
        message.textColor = .white
        message.textAlignment = .center
        message.numberOfLines = 0

        let retry = UIButton(type: .system)
        retry.setTitle("Play Again", for: .normal)
        retry.backgroundColor = ThemeManager.shared.currentTintColor
        retry.setTitleColor(.white, for: .normal)
        retry.layer.cornerRadius = 12
        retry.heightAnchor.constraint(equalToConstant: 50).isActive = true
        retry.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        let home = UIButton(type: .system)
        home.setTitle("Home", for: .normal)
        home.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        home.setTitleColor(.white, for: .normal)
        home.layer.cornerRadius = 12
        home.heightAnchor.constraint(equalToConstant: 50).isActive = true
        home.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)

        let board = UIButton(type: .system)
        board.setTitle("Leaderboard", for: .normal)
        board.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        board.setTitleColor(.white, for: .normal)
        board.layer.cornerRadius = 12
        board.heightAnchor.constraint(equalToConstant: 50).isActive = true
        board.addTarget(self, action: #selector(boardTapped), for: .touchUpInside)

        let cardStack = UIStackView(arrangedSubviews: [scoreLabel, levelLabel, message])
        cardStack.axis = .vertical
        cardStack.spacing = 8
        card.addSubview(cardStack)
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            cardStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            cardStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            cardStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])

        let buttons = UIStackView(arrangedSubviews: [retry, home, board])
        buttons.axis = .vertical
        buttons.spacing = 12

        let root = UIStackView(arrangedSubviews: [titleLabel, card, buttons])
        root.axis = .vertical
        root.spacing = 18
        view.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            root.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            root.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            root.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func retryTapped() {
        if let nav = navigationController {
            if let levelVC = nav.viewControllers.first(where: { $0 is LevelsViewController }) {
                nav.popToViewController(levelVC, animated: false)
                let newGame = GameViewController(level: level)
                nav.pushViewController(newGame, animated: true)
            } else {
                nav.popViewController(animated: true)
            }
        }
    }

    @objc private func homeTapped() { navigationController?.popToRootViewController(animated: true) }
    @objc private func boardTapped() { navigationController?.pushViewController(LeaderboardViewController(), animated: true) }

    override func gradientColorsForScreen() -> [UIColor] { ThemeManager.shared.gradientForScreen("GameOver") }
}