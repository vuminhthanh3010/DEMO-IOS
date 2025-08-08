import UIKit

class SplashViewController: BaseViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideBackButton()
        startAnimation()
        scheduleTransition()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupTitleLabel()
        setupSubtitleLabel()
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "PULSE TAP MASTER"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 36) ?? UIFont.boldSystemFont(ofSize: 36)
        titleLabel.textColor = isDarkMode() ? .white : UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        // Add shadow effect
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowRadius = 4
        
        view.addSubview(titleLabel)
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.text = "Master the Rhythm, Feel the Pulse"
        subtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18)
        subtitleLabel.textColor = isDarkMode() ? 
            UIColor(white: 0.8, alpha: 1.0) : 
            UIColor(red: 0.4, green: 0.5, blue: 0.7, alpha: 1.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.alpha = 0
        subtitleLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        
        view.addSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // Subtitle Label
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Animation Methods
    private func startAnimation() {
        // Title animation
        UIView.animate(withDuration: 1.2, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }, completion: nil)
        
        // Subtitle animation
        UIView.animate(withDuration: 0.8, delay: 0.8, options: .curveEaseOut, animations: {
            self.subtitleLabel.alpha = 1
            self.subtitleLabel.transform = .identity
        }, completion: nil)
        
        // Pulse effect for title
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.addPulseEffect()
        }
    }
    
    private func addPulseEffect() {
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: nil)
    }
    
    private func scheduleTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToHome()
        }
    }
    
    private func navigateToHome() {
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    // MARK: - Override Gradient Colors
    override func getGradientColors() -> [CGColor] {
        if isDarkMode() {
            return [
                UIColor(red: 0.1, green: 0.0, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0).cgColor,
                UIColor(red: 0.3, green: 0.2, blue: 0.6, alpha: 1.0).cgColor
            ]
        } else {
            return [
                UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0).cgColor,
                UIColor(red: 0.9, green: 0.8, blue: 1.0, alpha: 1.0).cgColor,
                UIColor(red: 1.0, green: 0.9, blue: 0.95, alpha: 1.0).cgColor
            ]
        }
    }
}