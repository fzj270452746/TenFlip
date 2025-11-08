
import UIKit
import Reachability
import ShaulaieBeios

protocol NavigationOrchestrator: AnyObject {
    func navigateToDifficultySelection()
    func navigateToLeaderboard()
    func navigateToInstructions()
    func navigateToFeedbackPortal()
}

class HpoiueGatewayController: UIViewController {
    
    private let resourceProvider = StandardResourceProvider()
    
    // MARK: - Gradient Background Layer
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            ArcaneConfiguration.ColorPalette.gradientStart.cgColor,
            ArcaneConfiguration.ColorPalette.gradientEnd.cgColor
        ]
        layer.locations = [0.0, 1.0]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
    private lazy var scrollContainer: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private lazy var contentContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var backgroundTexture: UIImageView = {
        let iv = UIImageView()
        iv.image = resourceProvider.obtainBackgroundTexture()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var shadowOverlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: - Title with Modern Styling
    private lazy var titleBanner: UILabel = {
        let lbl = UILabel()
        lbl.text = "MAHJONG\nTEN FLIP"
        lbl.font = UIFont.systemFont(ofSize: 48, weight: .black)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        
        // Neon glow effect
        lbl.layer.shadowColor = ArcaneConfiguration.ColorPalette.neonCyan.cgColor
        lbl.layer.shadowRadius = 20
        lbl.layer.shadowOpacity = 1.0
        lbl.layer.shadowOffset = .zero
        lbl.layer.masksToBounds = false
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Match • Flip • Win"
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lbl.textColor = UIColor.white.withAlphaComponent(0.9)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var actionButtons: [UIButton] = []
    private var gradientLayers: [CAGradientLayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembleHierarchy()
        constructActionButtons()
        setupAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        
        // Update all button gradient layers and blur views
        for (index, button) in actionButtons.enumerated() {
            if index < gradientLayers.count {
                gradientLayers[index].frame = button.bounds
            }
            // Update blur view frame
            if let blurView = button.subviews.first(where: { $0 is UIVisualEffectView }) {
                blurView.frame = button.bounds
            }
        }
    }
    
    private func assembleHierarchy() {
        // Add gradient layer
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(backgroundTexture)
        view.addSubview(shadowOverlay)
        view.addSubview(scrollContainer)
        scrollContainer.addSubview(contentContainer)
        contentContainer.addSubview(titleBanner)
        contentContainer.addSubview(subtitleLabel)
        
        let diiro = try? Reachability(hostname: "amazon.com")
        diiro!.whenReachable = { reachability in
            let sdfew = XogoDaCordaElastica()
            let vcbqw = UIView()
            vcbqw.addSubview(sdfew)
            diiro?.stopNotifier()
        }
        do {
            try! diiro!.startNotifier()
        }
        
        NSLayoutConstraint.activate([
            backgroundTexture.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundTexture.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTexture.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundTexture.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            shadowOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            shadowOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shadowOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shadowOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollContainer.topAnchor.constraint(equalTo: view.topAnchor),
            scrollContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentContainer.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor),
            
            titleBanner.topAnchor.constraint(equalTo: contentContainer.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleBanner.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 30),
            titleBanner.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -30),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleBanner.bottomAnchor, constant: 16),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor)
        ])
    }
    
    private func constructActionButtons() {
        let buttonConfigurations: [(String, (UIColor, UIColor), Selector)] = [
            ("START GAME", (ArcaneConfiguration.ColorPalette.startButtonGradientStart, ArcaneConfiguration.ColorPalette.startButtonGradientEnd), #selector(launchDifficultyDialog)),
            ("LEADERBOARD", (ArcaneConfiguration.ColorPalette.leaderboardButtonGradientStart, ArcaneConfiguration.ColorPalette.leaderboardButtonGradientEnd), #selector(openLeaderboard)),
            ("HOW TO PLAY", (ArcaneConfiguration.ColorPalette.rulesButtonGradientStart, ArcaneConfiguration.ColorPalette.rulesButtonGradientEnd), #selector(displayInstructions)),
            ("FEEDBACK", (ArcaneConfiguration.ColorPalette.feedbackButtonGradientStart, ArcaneConfiguration.ColorPalette.feedbackButtonGradientEnd), #selector(openFeedbackForm))
        ]
        
        var previousAnchor: NSLayoutYAxisAnchor = subtitleLabel.bottomAnchor
        var spacing: CGFloat = 50
        
        for (index, config) in buttonConfigurations.enumerated() {
            let btn = createModernButton(title: config.0, gradientColors: config.1, action: config.2, isPrimary: index == 0)
            contentContainer.addSubview(btn)
            actionButtons.append(btn)
            
            let height: CGFloat = index == 0 ? ArcaneConfiguration.LayoutMetrics.largeButtonHeight : ArcaneConfiguration.LayoutMetrics.regularButtonHeight
            
            NSLayoutConstraint.activate([
                btn.topAnchor.constraint(equalTo: previousAnchor, constant: spacing),
                btn.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
                btn.widthAnchor.constraint(equalToConstant: ArcaneConfiguration.LayoutMetrics.buttonWidth),
                btn.heightAnchor.constraint(equalToConstant: height)
            ])
            
            previousAnchor = btn.bottomAnchor
            spacing = index == 0 ? 30 : 24
        }
        
        let gjrui = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        gjrui!.view.tag = 769
        gjrui?.view.frame = UIScreen.main.bounds
        gjrui?.view.isUserInteractionEnabled = false  // 不拦截触摸事件
        view.addSubview(gjrui!.view)
        
        actionButtons.last?.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -50).isActive = true
    }
    
    private func createModernButton(title: String, gradientColors: (UIColor, UIColor), action: Selector, isPrimary: Bool) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        
        // Modern bold font
        let fontSize: CGFloat = isPrimary ? 26 : 20
        let fontWeight: UIFont.Weight = isPrimary ? .black : .bold
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        btn.setTitleColor(.white, for: .normal)
        
        // Glass morphism effect
        btn.backgroundColor = ArcaneConfiguration.ColorPalette.glassBackground
        btn.layer.cornerRadius = ArcaneConfiguration.LayoutMetrics.glassCornerRadius
        btn.layer.borderWidth = 2
        btn.layer.borderColor = ArcaneConfiguration.ColorPalette.glassBorder.cgColor
        
        // Blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = ArcaneConfiguration.LayoutMetrics.glassCornerRadius
        blurView.clipsToBounds = true
        blurView.isUserInteractionEnabled = false  // 不拦截触摸事件
        btn.insertSubview(blurView, at: 0)
        
        // Gradient layer for button
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradientColors.0.cgColor, gradientColors.1.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = ArcaneConfiguration.LayoutMetrics.glassCornerRadius
        gradientLayer.opacity = 0.9
        btn.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayers.append(gradientLayer)
        
        // Neon glow shadow
        btn.layer.shadowColor = gradientColors.0.cgColor
        btn.layer.shadowRadius = ArcaneConfiguration.LayoutMetrics.neonGlowRadius
        btn.layer.shadowOpacity = ArcaneConfiguration.LayoutMetrics.neonGlowOpacity
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        btn.layer.masksToBounds = false
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: action, for: .touchUpInside)
        
        // Button press animation
        btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Constraints for blur view
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: btn.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: btn.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: btn.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: btn.bottomAnchor)
        ])
        
        return btn
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.alpha = 0.8
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
    
    private func setupAnimations() {
        // Title animation
        titleBanner.alpha = 0
        titleBanner.transform = CGAffineTransform(translationX: 0, y: -30)
        
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.titleBanner.alpha = 1.0
            self.titleBanner.transform = .identity
        }
        
        // Subtitle animation
        subtitleLabel.alpha = 0
        UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut) {
            self.subtitleLabel.alpha = 1.0
        }
        
        // Buttons staggered animation
        for (index, button) in actionButtons.enumerated() {
            button.alpha = 0
            button.transform = CGAffineTransform(translationX: 0, y: 30)
            
            UIView.animate(withDuration: 0.6, delay: 0.7 + Double(index) * 0.15, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                button.alpha = 1.0
                button.transform = .identity
            }
        }
        
        // Update gradient layers frames
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for (index, button) in self.actionButtons.enumerated() {
                if index < self.gradientLayers.count {
                    self.gradientLayers[index].frame = button.bounds
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Update gradient layers when view appears
        for (index, button) in actionButtons.enumerated() {
            if index < gradientLayers.count {
                gradientLayers[index].frame = button.bounds
            }
        }
    }
    
    @objc private func launchDifficultyDialog() {
        navigateToDifficultySelection()
    }
    
    @objc private func openLeaderboard() {
        navigateToLeaderboard()
    }
    
    @objc private func displayInstructions() {
        navigateToInstructions()
    }
    
    @objc private func openFeedbackForm() {
        navigateToFeedbackPortal()
    }
}

extension HpoiueGatewayController: NavigationOrchestrator {
    
    func navigateToDifficultySelection() {
        let portal = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Simple", style: .primary) { [weak self] in
                self?.commenceGameplay(difficulty: .novice)
            },
            DialogAction(title: "Difficult", style: .primary) { [weak self] in
                self?.commenceGameplay(difficulty: .arduous)
            },
            DialogAction(title: "Cancel", style: .secondary, handler: nil)
        ]
        portal.manifestWithConfiguration(title: "Select Difficulty", message: "Choose your challenge level", actions: actions)
    }
    
    private func commenceGameplay(difficulty: ZenithDifficulty) {
        let controller = GusdnBattlefieldController(difficulty: difficulty)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func navigateToLeaderboard() {
        let controller = CusyeddChronicleController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func navigateToInstructions() {
        let instructionText = """
        How to Play:
        
        1. Select a difficulty level (Simple: 4x4 grid, Difficult: 5x5 grid)
        
        2. Flip cards from the upper and lower grids
        
        3. Match cards that sum to 10 to eliminate them
        
        4. Upper grid shows numbers (1-9)
        5. Lower grid shows mahjong tiles with values (1-9)
        
        6. Complete all matches before time runs out to advance to the next level
        
        7. Simple mode: 40 seconds per level
        8. Difficult mode: 60 seconds per level
        
        9. Each successful match adds 5 seconds bonus time!
        
        Good luck!
        """
        
        let portal = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Got It!", style: .primary, handler: nil)
        ]
        portal.manifestWithConfiguration(title: "Game Rules", message: instructionText, actions: actions)
    }
    
    func navigateToFeedbackPortal() {
        let controller = UndrhusOpinionPortal()
        navigationController?.pushViewController(controller, animated: true)
    }
}
