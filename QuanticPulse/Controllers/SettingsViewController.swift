import UIKit
import StoreKit

final class SettingsViewController: BaseViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private enum Row: CaseIterable { case darkMode, share, rate, experimental, version }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func gradientColorsForScreen() -> [UIColor] { ThemeManager.shared.gradientForScreen("Settings") }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { Row.allCases.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        cell.textLabel?.textColor = ThemeManager.shared.primaryTextColor
        cell.detailTextLabel?.textColor = ThemeManager.shared.secondaryTextColor
        switch Row.allCases[indexPath.row] {
        case .darkMode:
            cell.textLabel?.text = "Dark Mode"
            let sw = UISwitch()
            sw.isOn = ThemeManager.shared.isDarkModeEnabled
            sw.addTarget(self, action: #selector(toggleDark(_:)), for: .valueChanged)
            cell.accessoryView = sw
        case .share:
            cell.textLabel?.text = "Share App"
            cell.detailTextLabel?.text = "Invite friends to play"
            cell.accessoryType = .disclosureIndicator
        case .rate:
            cell.textLabel?.text = "Rate App"
            cell.detailTextLabel?.text = "Leave a review"
            cell.accessoryType = .disclosureIndicator
        case .version:
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
            cell.textLabel?.text = "Version"
            cell.detailTextLabel?.text = version
            cell.selectionStyle = .none
        case .experimental:
            cell.textLabel?.text = "Experimental Challenge Mode"
            cell.detailTextLabel?.text = "Coming soon"
            cell.selectionStyle = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Row.allCases[indexPath.row] {
        case .share:
            let url = URL(string: "https://apps.apple.com/app/id0000000000")!
            let vc = UIActivityViewController(activityItems: ["Try QuanticPulse!", url], applicationActivities: nil)
            present(vc, animated: true)
        case .rate:
            if let scene = view.window?.windowScene { SKStoreReviewController.requestReview(in: scene) }
        default: break
        }
    }

    @objc private func toggleDark(_ sender: UISwitch) {
        ThemeManager.shared.isDarkModeEnabled = sender.isOn
        if let window = view.window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.applyThemeAndGradient()
            })
        }
    }
}