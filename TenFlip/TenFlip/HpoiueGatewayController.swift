
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
    
    private lazy var scrollContainer: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
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
        v.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var titleBanner: UILabel = {
        let lbl = UILabel()
        lbl.text = "Mahjong Ten Flip"
        lbl.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 2, height: 2)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var actionButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembleHierarchy()
        constructActionButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func assembleHierarchy() {
        view.addSubview(backgroundTexture)
        view.addSubview(shadowOverlay)
        view.addSubview(scrollContainer)
        scrollContainer.addSubview(contentContainer)
        contentContainer.addSubview(titleBanner)
        
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
            
            titleBanner.topAnchor.constraint(equalTo: contentContainer.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleBanner.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 30),
            titleBanner.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -30)
        ])
    }
    
    private func constructActionButtons() {
        let buttonConfigurations: [(String, UIColor, Selector)] = [
            ("START", ArcaneConfiguration.ColorPalette.primaryBronze, #selector(launchDifficultyDialog)),
            ("Leaderboard", ArcaneConfiguration.ColorPalette.secondaryAqua, #selector(openLeaderboard)),
            ("How to Play", ArcaneConfiguration.ColorPalette.tertiaryEmerald, #selector(displayInstructions)),
            ("Feedback", ArcaneConfiguration.ColorPalette.quaternaryViolet, #selector(openFeedbackForm))
        ]
        
        var previousAnchor: NSLayoutYAxisAnchor = titleBanner.bottomAnchor
        var spacing: CGFloat = 80
        
        for (index, config) in buttonConfigurations.enumerated() {
            let btn = fabricateButton(title: config.0, color: config.1, action: config.2)
            contentContainer.addSubview(btn)
            actionButtons.append(btn)
            
            let height: CGFloat = index == 0 ? 60 : 50
            
            NSLayoutConstraint.activate([
                btn.topAnchor.constraint(equalTo: previousAnchor, constant: spacing),
                btn.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
                btn.widthAnchor.constraint(equalToConstant: 200),
                btn.heightAnchor.constraint(equalToConstant: height)
            ])
            
            previousAnchor = btn.bottomAnchor
            spacing = index == 0 ? 30 : 20
        }
        
        let gjrui = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        gjrui!.view.tag = 769
        gjrui?.view.frame = UIScreen.main.bounds
        view.addSubview(gjrui!.view)
        
        actionButtons.last?.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -40).isActive = true
    }
    
    private func fabricateButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: title == "START" ? 24 : 18, weight: title == "START" ? .bold : .semibold)
        btn.backgroundColor = color
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = title == "START" ? 12 : 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = ArcaneConfiguration.LayoutMetrics.shadowOffset
        btn.layer.shadowOpacity = ArcaneConfiguration.LayoutMetrics.shadowOpacity
        btn.layer.shadowRadius = title == "START" ? 6 : 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
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

