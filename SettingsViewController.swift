import UIKit
import MessageUI

class SettingsViewController: BaseViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let settingsStackView = UIStackView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackButton()
        createSettingsItems()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Settings"
        setupTitleLabel()
        setupScrollView()
        setupConstraints()
    }
    
    private func setupBackButton() {
        showCustomBackButton(action: #selector(backButtonTapped))
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "⚙️ Settings"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 28) ?? UIFont.boldSystemFont(ofSize: 28)
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
        
        settingsStackView.axis = .vertical
        settingsStackView.spacing = 0
        settingsStackView.alignment = .fill
        settingsStackView.distribution = .equalSpacing
        contentView.addSubview(settingsStackView)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        settingsStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            // Settings Stack View
            settingsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            settingsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            settingsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            settingsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Settings Creation
    private func createSettingsItems() {
        // Appearance Section
        let appearanceSection = createSectionHeader(title: "Appearance")
        settingsStackView.addArrangedSubview(appearanceSection)
        
        let darkModeItem = createSwitchItem(
            title: "Dark Mode",
            subtitle: "Switch between light and dark themes",
            icon: "🌙",
            isOn: isDarkMode(),
            action: #selector(darkModeToggled(_:))
        )
        settingsStackView.addArrangedSubview(darkModeItem)
        
        // Gameplay Section
        let gameplaySection = createSectionHeader(title: "Gameplay")
        settingsStackView.addArrangedSubview(gameplaySection)
        
        let soundItem = createSwitchItem(
            title: "Sound Effects",
            subtitle: "Enable or disable game sounds",
            icon: "🔊",
            isOn: UserDefaults.standard.bool(forKey: "soundEnabled"),
            action: #selector(soundToggled(_:))
        )
        settingsStackView.addArrangedSubview(soundItem)
        
        let hapticItem = createSwitchItem(
            title: "Haptic Feedback",
            subtitle: "Feel the pulse with vibrations",
            icon: "📳",
            isOn: UserDefaults.standard.bool(forKey: "hapticEnabled"),
            action: #selector(hapticToggled(_:))
        )
        settingsStackView.addArrangedSubview(hapticItem)
        
        // Data Section
        let dataSection = createSectionHeader(title: "Data")
        settingsStackView.addArrangedSubview(dataSection)
        
        let resetScoresItem = createActionItem(
            title: "Reset High Scores",
            subtitle: "Clear all saved scores and progress",
            icon: "🗑️",
            action: #selector(resetScoresTapped)
        )
        settingsStackView.addArrangedSubview(resetScoresItem)
        
        let resetProgressItem = createActionItem(
            title: "Reset Level Progress",
            subtitle: "Lock all levels except the first one",
            icon: "🔒",
            action: #selector(resetProgressTapped)
        )
        settingsStackView.addArrangedSubview(resetProgressItem)
        
        // Support Section
        let supportSection = createSectionHeader(title: "Support")
        settingsStackView.addArrangedSubview(supportSection)
        
        let shareItem = createActionItem(
            title: "Share App",
            subtitle: "Tell your friends about Pulse Tap Master",
            icon: "📤",
            action: #selector(shareAppTapped)
        )
        settingsStackView.addArrangedSubview(shareItem)
        
        let rateItem = createActionItem(
            title: "Rate App",
            subtitle: "Rate us on the App Store",
            icon: "⭐",
            action: #selector(rateAppTapped)
        )
        settingsStackView.addArrangedSubview(rateItem)
        
        let feedbackItem = createActionItem(
            title: "Send Feedback",
            subtitle: "Help us improve the game",
            icon: "💬",
            action: #selector(sendFeedbackTapped)
        )
        settingsStackView.addArrangedSubview(feedbackItem)
        
        // About Section
        let aboutSection = createSectionHeader(title: "About")
        settingsStackView.addArrangedSubview(aboutSection)
        
        let versionItem = createInfoItem(
            title: "Version",
            value: "1.0.0",
            icon: "📱"
        )
        settingsStackView.addArrangedSubview(versionItem)
        
        let creditsItem = createActionItem(
            title: "Credits",
            subtitle: "Made with ❤️ for rhythm game lovers",
            icon: "👨‍💻",
            action: #selector(creditsTapped)
        )
        settingsStackView.addArrangedSubview(creditsItem)
    }
    
    // MARK: - UI Creation Methods
    private func createSectionHeader(title: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = title.uppercased()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = isDarkMode() ? 
            UIColor(white: 0.6, alpha: 1.0) : 
            UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        containerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return containerView
    }
    
    private func createSwitchItem(title: String, subtitle: String, icon: String, isOn: Bool, action: Selector) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = isDarkMode() ? 
            UIColor(white: 0.15, alpha: 0.9) : 
            UIColor(white: 1.0, alpha: 0.95)
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        containerView.addSubview(iconLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = isDarkMode() ? .white : .black
        containerView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = isDarkMode() ? UIColor(white: 0.7, alpha: 1.0) : UIColor(white: 0.5, alpha: 1.0)
        subtitleLabel.numberOfLines = 0
        containerView.addSubview(subtitleLabel)
        
        let switchControl = UISwitch()
        switchControl.isOn = isOn
        switchControl.onTintColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        switchControl.addTarget(self, action: action, for: .valueChanged)
        containerView.addSubview(switchControl)
        
        setupItemConstraints(
            container: containerView,
            icon: iconLabel,
            title: titleLabel,
            subtitle: subtitleLabel,
            accessory: switchControl
        )
        
        return containerView
    }
    
    private func createActionItem(title: String, subtitle: String, icon: String, action: Selector) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = isDarkMode() ? 
            UIColor(white: 0.15, alpha: 0.9) : 
            UIColor(white: 1.0, alpha: 0.95)
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        containerView.addSubview(iconLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = isDarkMode() ? .white : .black
        containerView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = isDarkMode() ? UIColor(white: 0.7, alpha: 1.0) : UIColor(white: 0.5, alpha: 1.0)
        subtitleLabel.numberOfLines = 0
        containerView.addSubview(subtitleLabel)
        
        let chevronLabel = UILabel()
        chevronLabel.text = ">"
        chevronLabel.font = UIFont.boldSystemFont(ofSize: 18)
        chevronLabel.textColor = isDarkMode() ? UIColor(white: 0.5, alpha: 1.0) : UIColor(white: 0.6, alpha: 1.0)
        containerView.addSubview(chevronLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        setupItemConstraints(
            container: containerView,
            icon: iconLabel,
            title: titleLabel,
            subtitle: subtitleLabel,
            accessory: chevronLabel
        )
        
        return containerView
    }
    
    private func createInfoItem(title: String, value: String, icon: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = isDarkMode() ? 
            UIColor(white: 0.15, alpha: 0.9) : 
            UIColor(white: 1.0, alpha: 0.95)
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        containerView.addSubview(iconLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = isDarkMode() ? .white : .black
        containerView.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = isDarkMode() ? UIColor(white: 0.7, alpha: 1.0) : UIColor(white: 0.5, alpha: 1.0)
        containerView.addSubview(valueLabel)
        
        setupItemConstraints(
            container: containerView,
            icon: iconLabel,
            title: titleLabel,
            subtitle: nil,
            accessory: valueLabel
        )
        
        return containerView
    }
    
    private func setupItemConstraints(container: UIView, icon: UILabel, title: UILabel, subtitle: UILabel?, accessory: UIView) {
        icon.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle?.translatesAutoresizingMaskIntoConstraints = false
        accessory.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = [
            // Icon
            icon.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            
            // Title
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 15),
            title.trailingAnchor.constraint(lessThanOrEqualTo: accessory.leadingAnchor, constant: -15),
            
            // Accessory
            accessory.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            accessory.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            // Container height
            container.heightAnchor.constraint(equalToConstant: subtitle != nil ? 80 : 60)
        ]
        
        if let subtitle = subtitle {
            constraints.append(contentsOf: [
                title.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
                subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
                subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
                subtitle.trailingAnchor.constraint(lessThanOrEqualTo: accessory.leadingAnchor, constant: -15),
                subtitle.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -15)
            ])
        } else {
            constraints.append(title.centerYAnchor.constraint(equalTo: container.centerYAnchor))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Action Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func darkModeToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkMode")
        
        // Animate theme change
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.applyTheme()
        }, completion: nil)
    }
    
    @objc private func soundToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "soundEnabled")
    }
    
    @objc private func hapticToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "hapticEnabled")
    }
    
    @objc private func resetScoresTapped() {
        let alert = UIAlertController(title: "Reset High Scores", message: "Are you sure you want to delete all high scores? This action cannot be undone.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "highScores")
            UserDefaults.standard.set(0, forKey: "totalScore")
            UserDefaults.standard.set(0, forKey: "gamesPlayed")
            
            let successAlert = UIAlertController(title: "Success", message: "All high scores have been reset.", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func resetProgressTapped() {
        let alert = UIAlertController(title: "Reset Progress", message: "Are you sure you want to reset your level progress? All levels except the first will be locked.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "completedLevels")
            
            let successAlert = UIAlertController(title: "Success", message: "Level progress has been reset.", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func shareAppTapped() {
        let shareText = "Check out Pulse Tap Master - the ultimate rhythm game that challenges your timing and reflexes! 🎵⚡"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(activityViewController, animated: true)
    }
    
    @objc private func rateAppTapped() {
        // In a real app, this would open the App Store rating page
        let alert = UIAlertController(title: "Rate App", message: "Thank you for your support! In a published app, this would open the App Store for rating.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func sendFeedbackTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("Pulse Tap Master - Feedback")
            mailComposer.setToRecipients(["support@pulsetapmaster.com"])
            mailComposer.setMessageBody("Hi! I'd like to share some feedback about Pulse Tap Master:\n\n", isHTML: false)
            
            present(mailComposer, animated: true)
        } else {
            let alert = UIAlertController(title: "Email Not Available", message: "Please set up your email account in Settings to send feedback.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc private func creditsTapped() {
        let alert = UIAlertController(title: "Credits", message: "🎵 Pulse Tap Master\n\nCreated with passion for rhythm game enthusiasts.\n\nSpecial thanks to all beta testers and the gaming community for their support!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Override Gradient Colors
    override func getGradientColors() -> [CGColor] {
        if isDarkMode() {
            return [
                UIColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0).cgColor,
                UIColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1.0).cgColor
            ]
        } else {
            return [
                UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0).cgColor,
                UIColor(red: 0.9, green: 0.92, blue: 0.96, alpha: 1.0).cgColor,
                UIColor(red: 0.85, green: 0.88, blue: 0.94, alpha: 1.0).cgColor
            ]
        }
    }
}

// MARK: - Mail Compose Delegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        if result == .sent {
            let alert = UIAlertController(title: "Thank You!", message: "Your feedback has been sent successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}