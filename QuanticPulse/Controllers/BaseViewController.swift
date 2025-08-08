import UIKit

class BaseViewController: UIViewController {
    private var gradientLayer: CAGradientLayer?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyThemeAndGradient()
        navigationController?.navigationBar.tintColor = ThemeManager.shared.currentTintColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.primaryTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: ThemeManager.shared.primaryTextColor]
    }

    func applyThemeAndGradient() {
        gradientLayer?.removeFromSuperlayer()
        let colors = gradientColorsForScreen()
        gradientLayer = GradientBackground.makeGradientLayer(bounds: view.bounds, colors: colors)
        if let gradientLayer = gradientLayer {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
        view.backgroundColor = ThemeManager.shared.backgroundColor
    }

    func gradientColorsForScreen() -> [UIColor] {
        return ThemeManager.shared.defaultGradient
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
}