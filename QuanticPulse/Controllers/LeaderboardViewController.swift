import UIKit

final class LeaderboardViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    private var entries: [LeaderboardEntry] = []
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leaderboard"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.1)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let raw = StorageManager.shared.loadLeaderboard()
        entries = raw.sorted { $0.score > $1.score }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { entries.count }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { "Rank • Name • Score • Level • Title" }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        let e = entries[indexPath.row]
        let rankTitle: String = e.score >= 150 ? "Super" : (e.score >= 100 ? "Pro" : "Rookie")
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        cell.textLabel?.text = "#\(indexPath.row + 1) • \(e.playerName) • \(e.score) pts • Lv \(e.levelId) • \(rankTitle)"
        cell.detailTextLabel?.text = formatter.string(from: e.date)
        return cell
    }

    override func gradientColorsForScreen() -> [UIColor] { ThemeManager.shared.gradientForScreen("Leaderboard") }
}