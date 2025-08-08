import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateGradientFrame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    // MARK: - Setup Methods
    private func setupBaseUI() {
        setupGradientBackground()
        setupNavigationBar()
    }
    
    private func setupGradientBackground() {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = getGradientColors()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = isDarkMode() ? .white : .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: isDarkMode() ? UIColor.white : UIColor.black
        ]
    }
    
    private func updateGradientFrame() {
        gradientLayer?.frame = view.bounds
    }
    
    // MARK: - Theme Methods
    func applyTheme() {
        setupGradientBackground()
        setupNavigationBar()
    }
    
    func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func toggleDarkMode() {
        let currentMode = isDarkMode()
        UserDefaults.standard.set(!currentMode, forKey: "isDarkMode")
        applyTheme()
    }
    
    // MARK: - Gradient Colors (Override in subclasses)
    func getGradientColors() -> [CGColor] {
        if isDarkMode() {
            return [
                UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0).cgColor
            ]
        } else {
            return [
                UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0).cgColor,
                UIColor(red: 0.8, green: 0.9, blue: 0.95, alpha: 1.0).cgColor
            ]
        }
    }
    
    // MARK: - Utility Methods
    func hideBackButton() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
    }
    
    func showCustomBackButton(action: Selector) {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: action
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    func createStyledButton(title: String, backgroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        
        if let bgColor = backgroundColor {
            button.backgroundColor = bgColor
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = isDarkMode() ? 
                UIColor(white: 0.2, alpha: 0.8) : 
                UIColor(white: 1.0, alpha: 0.9)
            button.setTitleColor(isDarkMode() ? .white : .black, for: .normal)
        }
        
        return button
    }
    
    func createStyledLabel(text: String, fontSize: CGFloat, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = isBold ? 
            UIFont.boldSystemFont(ofSize: fontSize) : 
            UIFont.systemFont(ofSize: fontSize)
        label.textColor = isDarkMode() ? .white : .black
        return label
    }
}