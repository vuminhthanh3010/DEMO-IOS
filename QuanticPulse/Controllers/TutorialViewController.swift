import UIKit

final class TutorialViewController: BaseViewController, UIPageViewControllerDataSource {
    private var pageVC: UIPageViewController!
    private let pages: [UIViewController] = [
        TutorialPage(text: "Watch the icons pulse in rhythm.", title: "Rhythm"),
        TutorialPage(text: "Pick the target instruction, then tap the correct icon exactly on its target pulse.", title: "Target"),
        TutorialPage(text: "Chain correct taps for streaks and bonus points!", title: "Streaks")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tutorial"
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.dataSource = self
        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.view.frame = view.bounds
        pageVC.didMove(toParent: self)
        pageVC.setViewControllers([pages.first!], direction: .forward, animated: true)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController), idx > 0 else { return nil }
        return pages[idx - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController), idx < pages.count - 1 else { return nil }
        return pages[idx + 1]
    }

    override func gradientColorsForScreen() -> [UIColor] { ThemeManager.shared.gradientForScreen("Tutorial") }
}

final class TutorialPage: UIViewController {
    private let text: String
    private let headline: String

    init(text: String, title: String) {
        self.text = text
        self.headline = title
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let titleLabel = UILabel()
        titleLabel.text = headline
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white

        let body = UILabel()
        body.text = text
        body.textAlignment = .center
        body.numberOfLines = 0
        body.textColor = .white

        let stack = UIStackView(arrangedSubviews: [titleLabel, body])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}