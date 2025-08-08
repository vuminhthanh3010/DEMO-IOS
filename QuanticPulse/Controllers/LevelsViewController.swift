import UIKit

final class LevelsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var levels: [Level] = []
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Levels"
        levels = StorageManager.shared.loadLevels()
        setupCollection()
    }

    private func setupCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(LevelCell.self, forCellWithReuseIdentifier: "LevelCell")
        cv.delegate = self
        cv.dataSource = self
        view.addSubview(cv)
        cv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView = cv
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { levels.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath) as! LevelCell
        let level = levels[indexPath.item]
        let unlocked = StorageManager.shared.isLevelUnlocked(level.id)
        cell.configure(with: level, unlocked: unlocked)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let level = levels[indexPath.item]
        guard StorageManager.shared.isLevelUnlocked(level.id) else {
            Toast.show(message: "Locked. Beat previous level!", in: view)
            return
        }
        let game = GameViewController(level: level)
        navigationController?.pushViewController(game, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let columns: CGFloat = width > 500 ? 3 : 2
        let spacing: CGFloat = 8 * (columns - 1) + 24
        let itemWidth = (width - spacing) / columns
        return CGSize(width: floor(itemWidth), height: 110)
    }

    override func gradientColorsForScreen() -> [UIColor] { ThemeManager.shared.gradientForScreen("Levels") }
}

final class LevelCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 14
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor

        let stack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stack.axis = .vertical
        stack.spacing = 6
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        detailLabel.font = .systemFont(ofSize: 14)
        detailLabel.textColor = .white
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    func configure(with level: Level, unlocked: Bool) {
        titleLabel.text = level.name
        let speed = String(format: "%.1fs/pulse", level.pulseSpeedSeconds)
        detailLabel.text = "Diff: \(level.difficulty) • \(speed) • Qs: \(level.questions.count)" + (unlocked ? "" : " • Locked")
        contentView.alpha = unlocked ? 1.0 : 0.5
    }
}