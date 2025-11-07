
import UIKit

class PristineGatewayController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tenflip")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mahjong Ten Flip"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.shadowColor = UIColor.black.withAlphaComponent(0.5)
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let leaderboardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Leaderboard", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 0.8, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rulesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("How to Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let feedbackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Feedback", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.7, green: 0.5, blue: 0.8, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        establishButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureInterface() {
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(startButton)
        contentView.addSubview(leaderboardButton)
        contentView.addSubview(rulesButton)
        contentView.addSubview(feedbackButton)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            startButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            startButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            
            leaderboardButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 30),
            leaderboardButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            leaderboardButton.widthAnchor.constraint(equalToConstant: 200),
            leaderboardButton.heightAnchor.constraint(equalToConstant: 50),
            
            rulesButton.topAnchor.constraint(equalTo: leaderboardButton.bottomAnchor, constant: 20),
            rulesButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rulesButton.widthAnchor.constraint(equalToConstant: 200),
            rulesButton.heightAnchor.constraint(equalToConstant: 50),
            
            feedbackButton.topAnchor.constraint(equalTo: rulesButton.bottomAnchor, constant: 20),
            feedbackButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            feedbackButton.widthAnchor.constraint(equalToConstant: 200),
            feedbackButton.heightAnchor.constraint(equalToConstant: 50),
            feedbackButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func establishButtonActions() {
        startButton.addTarget(self, action: #selector(initiateGameCommence), for: .touchUpInside)
        leaderboardButton.addTarget(self, action: #selector(displayPinnacleRecords), for: .touchUpInside)
        rulesButton.addTarget(self, action: #selector(presentGameplayInstructions), for: .touchUpInside)
        feedbackButton.addTarget(self, action: #selector(unveilFeedbackInterface), for: .touchUpInside)
    }
    
    @objc private func initiateGameCommence() {
        let dialog = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Simple", style: .primary) { [weak self] in
                self?.launchGameWithDifficulty(.novice)
            },
            DialogAction(title: "Difficult", style: .primary) { [weak self] in
                self?.launchGameWithDifficulty(.arduous)
            },
            DialogAction(title: "Cancel", style: .secondary, handler: nil)
        ]
        dialog.manifestWithConfiguration(title: "Select Difficulty", message: "Choose your challenge level", actions: actions)
    }
    
    private func launchGameWithDifficulty(_ difficulty: ZenithDifficulty) {
        let gameController = SovereignBattlefieldController(difficulty: difficulty)
        navigationController?.pushViewController(gameController, animated: true)
    }
    
    @objc private func displayPinnacleRecords() {
        let leaderboardController = IllustriousChronicleController()
        navigationController?.pushViewController(leaderboardController, animated: true)
    }
    
    @objc private func presentGameplayInstructions() {
        let rulesText = """
        How to Play:
        
        1. Select a difficulty level (Simple: 4x4 grid, Difficult: 5x5 grid)
        
        2. Flip cards from the upper and lower grids
        
        3. Match cards that sum to 10 to eliminate them
        
        4. Upper grid shows numbers (1-9)
        5. Lower grid shows mahjong tiles with values (1-9)
        
        6. Complete all matches before time runs out to advance to the next level
        
        7. Simple mode: 40 seconds per level
        8. Difficult mode: 60 seconds per level
        
        Good luck!
        """
        
        let dialog = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Got It!", style: .primary, handler: nil)
        ]
        dialog.manifestWithConfiguration(title: "Game Rules", message: rulesText, actions: actions)
    }
    
    @objc private func unveilFeedbackInterface() {
        let feedbackController = TranscendentOpinionPortal()
        navigationController?.pushViewController(feedbackController, animated: true)
    }
}

