import UIKit

class TutorialViewController: BaseViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let skipButton = UIButton(type: .system)
    
    // MARK: - Properties
    private let tutorialPages: [TutorialPage] = [
        TutorialPage(
            title: "Welcome to Pulse Tap Master! 🎵",
            description: "Learn the rhythm-based gameplay that will challenge your timing and reflexes.",
            imageName: "🎮",
            backgroundColor: UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.8)
        ),
        TutorialPage(
            title: "Watch the Pulse Pattern ⚡",
            description: "Icons will light up in a sequence. Pay attention to the timing and which icons light up at each pulse.",
            imageName: "👁️",
            backgroundColor: UIColor(red: 0.9, green: 0.6, blue: 0.2, alpha: 0.8)
        ),
        TutorialPage(
            title: "Follow the Instructions 📖",
            description: "Each challenge tells you exactly when and which icon to tap. For example: 'Tap icon 3 at pulse 2'",
            imageName: "📝",
            backgroundColor: UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 0.8)
        ),
        TutorialPage(
            title: "Time Your Tap Perfectly ⏰",
            description: "Tap the correct icon at the exact moment it lights up during the specified pulse. Timing is everything!",
            imageName: "🎯",
            backgroundColor: UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.8)
        ),
        TutorialPage(
            title: "Beware of Fake Pulses! ⚠️",
            description: "Some icons may light up at wrong times to confuse you. Only tap when the instruction says to!",
            imageName: "🚫",
            backgroundColor: UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.8)
        ),
        TutorialPage(
            title: "Master the Rhythm 🏆",
            description: "As you progress, pulses get faster and patterns become more complex. Practice makes perfect!",
            imageName: "👑",
            backgroundColor: UIColor(red: 0.8, green: 0.2, blue: 0.6, alpha: 0.8)
        )
    ]
    
    private var currentPage = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTutorialPages()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "How to Play"
        setupTitleLabel()
        setupScrollView()
        setupPageControl()
        setupSkipButton()
        setupConstraints()
    }
    
    private func setupBackButton() {
        showCustomBackButton(action: #selector(backButtonTapped))
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "How to Play Pulse Tap Master"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = isDarkMode() ? .white : UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
    }
    
    private func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = tutorialPages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = isDarkMode() ? 
            UIColor(white: 0.4, alpha: 1.0) : 
            UIColor(white: 0.7, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor = isDarkMode() ? 
            .white : 
            UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        view.addSubview(pageControl)
    }
    
    private func setupSkipButton() {
        skipButton.setTitle("Skip Tutorial", for: .normal)
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        skipButton.setTitleColor(isDarkMode() ? .white : UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0), for: .normal)
        skipButton.backgroundColor = isDarkMode() ? 
            UIColor(white: 0.2, alpha: 0.8) : 
            UIColor(white: 1.0, alpha: 0.9)
        skipButton.layer.cornerRadius = 20
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = isDarkMode() ? 
            UIColor(white: 0.4, alpha: 1.0).cgColor : 
            UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0).cgColor
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        view.addSubview(skipButton)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Skip Button
            skipButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skipButton.widthAnchor.constraint(equalToConstant: 120),
            skipButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            
            // Page Control
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTutorialPages() {
        let pageWidth = view.frame.width
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(tutorialPages.count), height: 0)
        
        for (index, tutorialPage) in tutorialPages.enumerated() {
            let pageView = createTutorialPageView(for: tutorialPage, at: index)
            scrollView.addSubview(pageView)
        }
    }
    
    private func createTutorialPageView(for page: TutorialPage, at index: Int) -> UIView {
        let pageView = UIView()
        let pageWidth = view.frame.width
        pageView.frame = CGRect(x: CGFloat(index) * pageWidth, y: 0, width: pageWidth, height: scrollView.frame.height)
        
        // Card container
        let cardView = UIView()
        cardView.backgroundColor = isDarkMode() ? 
            UIColor(white: 0.1, alpha: 0.9) : 
            UIColor(white: 1.0, alpha: 0.95)
        cardView.layer.cornerRadius = 25
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 15
        
        // Accent bar
        let accentBar = UIView()
        accentBar.backgroundColor = page.backgroundColor
        accentBar.layer.cornerRadius = 3
        cardView.addSubview(accentBar)
        
        // Icon label
        let iconLabel = UILabel()
        iconLabel.text = page.imageName
        iconLabel.font = UIFont.systemFont(ofSize: 80)
        iconLabel.textAlignment = .center
        cardView.addSubview(iconLabel)
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = page.title
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = isDarkMode() ? .white : .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        cardView.addSubview(titleLabel)
        
        // Description label
        let descriptionLabel = UILabel()
        descriptionLabel.text = page.description
        descriptionLabel.font = UIFont(name: "AvenirNext-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = isDarkMode() ? 
            UIColor(white: 0.8, alpha: 1.0) : 
            UIColor(white: 0.3, alpha: 1.0)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        cardView.addSubview(descriptionLabel)
        
        // Step indicator
        let stepLabel = UILabel()
        stepLabel.text = "Step \(index + 1) of \(tutorialPages.count)"
        stepLabel.font = UIFont.boldSystemFont(ofSize: 14)
        stepLabel.textColor = page.backgroundColor
        stepLabel.textAlignment = .center
        cardView.addSubview(stepLabel)
        
        pageView.addSubview(cardView)
        
        // Setup constraints
        cardView.translatesAutoresizingMaskIntoConstraints = false
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Card View
            cardView.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: pageView.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 30),
            cardView.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -30),
            cardView.heightAnchor.constraint(equalToConstant: 450),
            
            // Accent Bar
            accentBar.topAnchor.constraint(equalTo: cardView.topAnchor),
            accentBar.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            accentBar.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            accentBar.heightAnchor.constraint(equalToConstant: 6),
            
            // Step Label
            stepLabel.topAnchor.constraint(equalTo: accentBar.bottomAnchor, constant: 20),
            stepLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            // Icon Label
            iconLabel.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 20),
            iconLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            iconLabel.heightAnchor.constraint(equalToConstant: 100),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -20)
        ])
        
        return pageView
    }
    
    // MARK: - Action Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func skipButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func pageControlChanged() {
        let pageWidth = scrollView.frame.width
        let targetOffset = CGFloat(pageControl.currentPage) * pageWidth
        scrollView.setContentOffset(CGPoint(x: targetOffset, y: 0), animated: true)
    }
    
    // MARK: - Override Gradient Colors
    override func getGradientColors() -> [CGColor] {
        if isDarkMode() {
            return [
                UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.1, blue: 0.25, alpha: 1.0).cgColor,
                UIColor(red: 0.15, green: 0.15, blue: 0.35, alpha: 1.0).cgColor
            ]
        } else {
            return [
                UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0).cgColor,
                UIColor(red: 0.9, green: 0.94, blue: 0.98, alpha: 1.0).cgColor,
                UIColor(red: 0.85, green: 0.91, blue: 0.96, alpha: 1.0).cgColor
            ]
        }
    }
}

// MARK: - ScrollView Delegate
extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        if currentPage != self.currentPage && currentPage >= 0 && currentPage < tutorialPages.count {
            self.currentPage = currentPage
            pageControl.currentPage = currentPage
            
            // Add subtle haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
    }
}

// MARK: - Tutorial Page Model
private struct TutorialPage {
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: UIColor
}