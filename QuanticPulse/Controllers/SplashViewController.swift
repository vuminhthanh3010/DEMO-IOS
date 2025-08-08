import UIKit

final class SplashViewController: BaseViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "QuanticPulse"
        label.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.alpha = 0
        label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        } completion: { _ in }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let home = HomeViewController()
            self.navigationController?.pushViewController(home, animated: true)
        }
    }

    override func gradientColorsForScreen() -> [UIColor] { ThemeManager.shared.gradientForScreen("Splash") }
}