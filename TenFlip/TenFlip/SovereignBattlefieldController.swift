//
//  SovereignBattlefieldController.swift
//  TenFlip
//
//  Main Game Play Controller
//

import UIKit

class SovereignBattlefieldController: UIViewController {
    
    private var gameSession: EphemeralGameSession
    private var chronologicalTracker: Timer?
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tenflip")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("← Back", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let levelIndicator: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.shadowColor = UIColor.black.withAlphaComponent(0.5)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temporalDisplay: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.shadowColor = UIColor.black.withAlphaComponent(0.5)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var upperGridCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(MahjongCellArchetype.self, forCellWithReuseIdentifier: "MahjongCellArchetype")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.tag = 1
        collection.isScrollEnabled = false
        return collection
    }()
    
    private lazy var lowerGridCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(MahjongCellArchetype.self, forCellWithReuseIdentifier: "MahjongCellArchetype")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.tag = 2
        collection.isScrollEnabled = false
        return collection
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(difficulty: ZenithDifficulty) {
        self.gameSession = EphemeralGameSession(difficulty: difficulty)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        initiateNewRound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chronologicalTracker?.invalidate()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureInterface() {
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(backButton)
        view.addSubview(levelIndicator)
        view.addSubview(temporalDisplay)
        view.addSubview(upperGridCollection)
        view.addSubview(separatorView)
        view.addSubview(lowerGridCollection)
        
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        
        // Calculate grid size using view bounds (works correctly in iPad compatibility mode)
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        
        // Calculate available space
        let topSpace: CGFloat = 90 // safe area + level + time
        let separatorSpace: CGFloat = 8
        let bottomSpace: CGFloat = 30
        let availableHeight = viewHeight - topSpace - separatorSpace - bottomSpace
        let singleGridHeight = availableHeight / 2
        
        let availableWidth = viewWidth - 32
        let gridSize = min(availableWidth, singleGridHeight)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            levelIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            levelIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            levelIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            temporalDisplay.topAnchor.constraint(equalTo: levelIndicator.bottomAnchor, constant: 4),
            temporalDisplay.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            temporalDisplay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            upperGridCollection.topAnchor.constraint(equalTo: temporalDisplay.bottomAnchor, constant: 8),
            upperGridCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            upperGridCollection.widthAnchor.constraint(equalToConstant: gridSize),
            upperGridCollection.heightAnchor.constraint(equalToConstant: gridSize),
            
            separatorView.topAnchor.constraint(equalTo: upperGridCollection.bottomAnchor, constant: 4),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            lowerGridCollection.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 4),
            lowerGridCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lowerGridCollection.widthAnchor.constraint(equalToConstant: gridSize),
            lowerGridCollection.heightAnchor.constraint(equalToConstant: gridSize)
        ])
    }
    
    private func initiateNewRound() {
        gameSession.generateNewLevel()
        gameSession.gamePhase = .commenced
        refreshUserInterface()
        commenceTemporalCountdown()
    }
    
    private func refreshUserInterface() {
        levelIndicator.text = "Level \(gameSession.currentLevel)"
        temporalDisplay.text = "Time: \(gameSession.remainingTime)s"
        upperGridCollection.reloadData()
        lowerGridCollection.reloadData()
    }
    
    private func commenceTemporalCountdown() {
        chronologicalTracker?.invalidate()
        chronologicalTracker = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.processTemporalTick()
        }
    }
    
    private func processTemporalTick() {
        gameSession.remainingTime -= 1
        temporalDisplay.text = "Time: \(gameSession.remainingTime)s"
        
        if gameSession.remainingTime <= 10 {
            temporalDisplay.textColor = .red
        }
        
        if gameSession.remainingTime <= 0 {
            chronologicalTracker?.invalidate()
            executeGameTermination()
        }
    }
    
    private func processCardSelection(card: MysticTileEntity, fromUpperGrid: Bool) {
        if card.isEliminated {
            return
        }
        
        // If both selections are already made, don't allow new selection
        if gameSession.selectedFromUpper != nil && gameSession.selectedFromLower != nil {
            return
        }
        
        if fromUpperGrid {
            // Clicking upper grid
            if gameSession.selectedFromUpper != nil {
                // Upper already has a selection, cannot select from upper again
                return
            }
            // First selection from upper
            card.isRevealed = true
            gameSession.selectedFromUpper = card
        } else {
            // Clicking lower grid
            if gameSession.selectedFromLower != nil {
                // Lower already has a selection, cannot select from lower again
                return
            }
            // First selection from lower
            card.isRevealed = true
            gameSession.selectedFromLower = card
        }
        
        refreshUserInterface()
        
        // Check if both grids have a selection
        if let upperCard = gameSession.selectedFromUpper, let lowerCard = gameSession.selectedFromLower {
            evaluateMatchingAttempt(upperCard: upperCard, lowerCard: lowerCard)
        }
    }
    
    private func evaluateMatchingAttempt(upperCard: MysticTileEntity, lowerCard: MysticTileEntity) {
        let sum = upperCard.cardType.displayValue + lowerCard.cardType.displayValue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if sum == 10 {
                // Successful match - add 5 seconds bonus
                upperCard.isEliminated = true
                lowerCard.isEliminated = true
                self.gameSession.selectedFromUpper = nil
                self.gameSession.selectedFromLower = nil
                
                // Add 5 seconds time bonus
                self.gameSession.remainingTime += 5
                self.temporalDisplay.textColor = UIColor(red: 0.2, green: 1.0, blue: 0.4, alpha: 1.0) // Green flash
                
                self.refreshUserInterface()
                
                // Reset color back to white after a moment
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if self.gameSession.remainingTime > 10 {
                        self.temporalDisplay.textColor = .white
                    }
                }
                
                self.evaluateVictoryCondition()
            } else {
                // Failed match
                upperCard.isRevealed = false
                lowerCard.isRevealed = false
                self.gameSession.selectedFromUpper = nil
                self.gameSession.selectedFromLower = nil
                self.refreshUserInterface()
            }
        }
    }
    
    private func evaluateVictoryCondition() {
        let allEliminated = gameSession.upperGridCards.allSatisfy { $0.isEliminated } &&
                           gameSession.lowerGridCards.allSatisfy { $0.isEliminated }
        
        if allEliminated {
            chronologicalTracker?.invalidate()
            displayVictoryAnnouncement()
        }
    }
    
    private func displayVictoryAnnouncement() {
        let dialog = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Next Level", style: .primary) { [weak self] in
                self?.progressToNextLevel()
            },
            DialogAction(title: "Quit", style: .secondary) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        ]
        dialog.manifestWithConfiguration(
            title: "Level Complete!",
            message: "Congratulations! You've cleared Level \(gameSession.currentLevel)!",
            actions: actions
        )
    }
    
    private func progressToNextLevel() {
        gameSession.currentLevel += 1
        initiateNewRound()
        temporalDisplay.textColor = .white
    }
    
    private func executeGameTermination() {
        gameSession.gamePhase = .vanquished
        
        // Save to leaderboard if level > 1
        if gameSession.currentLevel > 1 {
            let record = PinnacleRecord(
                difficulty: gameSession.difficulty,
                achievedLevel: gameSession.currentLevel,
                timestamp: Date()
            )
            AncientVaultKeeper.shared.savePinnacleRecord(record)
        }
        
        let dialog = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Try Again", style: .primary) { [weak self] in
                self?.restartGame()
            },
            DialogAction(title: "Quit", style: .secondary) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        ]
        
        let message = gameSession.currentLevel > 1 ?
            "You reached Level \(gameSession.currentLevel)!\nYour score has been saved." :
            "Time's up! Try again to reach higher levels."
        
        dialog.manifestWithConfiguration(
            title: "Game Over",
            message: message,
            actions: actions
        )
    }
    
    private func restartGame() {
        gameSession.currentLevel = 1
        initiateNewRound()
        temporalDisplay.textColor = .white
    }
    
    @objc private func navigateBack() {
        chronologicalTracker?.invalidate()
        
        let dialog = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Yes", style: .destructive) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            DialogAction(title: "No", style: .secondary, handler: nil)
        ]
        dialog.manifestWithConfiguration(
            title: "Quit Game",
            message: "Are you sure you want to quit the game?",
            actions: actions
        )
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension SovereignBattlefieldController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameSession.difficulty.totalCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MahjongCellArchetype", for: indexPath) as! MahjongCellArchetype
        
        let isUpperGrid = collectionView.tag == 1
        let cards = isUpperGrid ? gameSession.upperGridCards : gameSession.lowerGridCards
        
        if indexPath.item < cards.count {
            let card = cards[indexPath.item]
            cell.configureWithCard(card)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isUpperGrid = collectionView.tag == 1
        let cards = isUpperGrid ? gameSession.upperGridCards : gameSession.lowerGridCards
        
        if indexPath.item < cards.count {
            let card = cards[indexPath.item]
            processCardSelection(card: card, fromUpperGrid: isUpperGrid)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = gameSession.difficulty.gridDimension
        let spacing: CGFloat = 4
        let totalSpacing = spacing * CGFloat(dimension - 1)
        
        // Use collectionView's actual bounds for accurate calculation
        let collectionWidth = collectionView.bounds.width
        let collectionHeight = collectionView.bounds.height
        
        // Calculate cell size based on the actual collection view size
        let availableWidth = collectionWidth - totalSpacing
        let availableHeight = collectionHeight - totalSpacing
        
        // Use the smaller dimension to ensure cells fit
        let cellSizeByWidth = availableWidth / CGFloat(dimension)
        let cellSizeByHeight = availableHeight / CGFloat(dimension)
        let cellSize = min(cellSizeByWidth, cellSizeByHeight)
        
        return CGSize(width: cellSize, height: cellSize)
    }
}

// MARK: - Collection View Cell
class MahjongCellArchetype: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    // Gradient border layer (used as mask for border effect)
    private let gradientBorderLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            ArcaneConfiguration.ColorPalette.neonCyan.cgColor,
            ArcaneConfiguration.ColorPalette.neonPurple.cgColor,
            ArcaneConfiguration.ColorPalette.neonPink.cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.cornerRadius = 10
        return layer
    }()
    
    // Border view for gradient effect
    private let borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false  // 不拦截触摸事件
        return view
    }()
    
    // Inner border layer (for revealed cards)
    private let innerBorderLayer: CALayer = {
        let layer = CALayer()
        layer.borderWidth = 2
        layer.cornerRadius = 8
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = .clear
        
        // Add container view and border view
        contentView.addSubview(borderView)
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        
        // Add gradient border layer to border view
        borderView.layer.insertSublayer(gradientBorderLayer, at: 0)
        imageView.layer.addSublayer(innerBorderLayer)
        
        NSLayoutConstraint.activate([
            // Border view (slightly larger for border effect)
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Container view (inner content)
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            // Image view
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2)
        ])
        
        // Initial styling
        updateBorderStyle(isRevealed: false, isEliminated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayersFrame()
    }
    
    private func updateLayersFrame() {
        gradientBorderLayer.frame = borderView.bounds
        innerBorderLayer.frame = imageView.bounds
        
        // Create gradient border effect using mask
        let borderWidth: CGFloat = 3
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: borderView.bounds, cornerRadius: 10)
        let innerPath = UIBezierPath(roundedRect: borderView.bounds.insetBy(dx: borderWidth, dy: borderWidth), cornerRadius: 8)
        path.append(innerPath.reversing())
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        gradientBorderLayer.mask = maskLayer
    }
    
    private func updateBorderStyle(isRevealed: Bool, isEliminated: Bool) {
        if isEliminated {
            // Eliminated cards - dimmed border
            gradientBorderLayer.opacity = 0.2
            borderView.alpha = 0.2
            innerBorderLayer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
            innerBorderLayer.borderWidth = 1
            containerView.layer.shadowOpacity = 0
            borderView.layer.shadowOpacity = 0
        } else if isRevealed {
            // Revealed cards - bright neon border with glow
            gradientBorderLayer.opacity = 1.0
            borderView.alpha = 1.0
            
            // Inner border with matching color
            innerBorderLayer.borderColor = ArcaneConfiguration.ColorPalette.neonCyan.cgColor
            innerBorderLayer.borderWidth = 2
            
            // Neon glow shadow on border view
            borderView.layer.shadowColor = ArcaneConfiguration.ColorPalette.neonCyan.cgColor
            borderView.layer.shadowRadius = 8
            borderView.layer.shadowOpacity = 0.8
            borderView.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            // Container shadow
            containerView.layer.shadowColor = ArcaneConfiguration.ColorPalette.neonPurple.cgColor
            containerView.layer.shadowRadius = 4
            containerView.layer.shadowOpacity = 0.6
            containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            // Add pulsing animation
            addPulsingAnimation()
        } else {
            // Hidden cards - subtle border
            gradientBorderLayer.opacity = 0.6
            borderView.alpha = 0.6
            innerBorderLayer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            innerBorderLayer.borderWidth = 1
            borderView.layer.shadowColor = UIColor.white.cgColor
            borderView.layer.shadowRadius = 4
            borderView.layer.shadowOpacity = 0.4
            borderView.layer.shadowOffset = CGSize(width: 0, height: 0)
            containerView.layer.shadowOpacity = 0
            
            // Remove pulsing animation
            removePulsingAnimation()
        }
        
        // Update border mask
        DispatchQueue.main.async { [weak self] in
            self?.updateLayersFrame()
        }
    }
    
    private func addPulsingAnimation() {
        // Remove existing animation
        removePulsingAnimation()
        
        // Add pulsing glow effect on border view
        let pulseAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        pulseAnimation.fromValue = 0.6
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 1.0
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        borderView.layer.add(pulseAnimation, forKey: "pulsingGlow")
        
        // Add border color animation
        let borderAnimation = CABasicAnimation(keyPath: "colors")
        borderAnimation.fromValue = [
            ArcaneConfiguration.ColorPalette.neonCyan.cgColor,
            ArcaneConfiguration.ColorPalette.neonPurple.cgColor,
            ArcaneConfiguration.ColorPalette.neonPink.cgColor
        ]
        borderAnimation.toValue = [
            ArcaneConfiguration.ColorPalette.neonPink.cgColor,
            ArcaneConfiguration.ColorPalette.neonCyan.cgColor,
            ArcaneConfiguration.ColorPalette.neonPurple.cgColor
        ]
        borderAnimation.duration = 2.0
        borderAnimation.autoreverses = true
        borderAnimation.repeatCount = .greatestFiniteMagnitude
        borderAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradientBorderLayer.add(borderAnimation, forKey: "borderColorPulse")
    }
    
    private func removePulsingAnimation() {
        containerView.layer.removeAnimation(forKey: "pulsingGlow")
        gradientBorderLayer.removeAnimation(forKey: "borderColorPulse")
    }
    
    func configureWithCard(_ card: MysticTileEntity) {
        if card.isEliminated {
            imageView.alpha = 0.2
            imageView.image = nil
            updateBorderStyle(isRevealed: false, isEliminated: true)
        } else if card.isRevealed {
            imageView.alpha = 1.0
            imageView.image = UIImage(named: card.cardType.imageName)
            updateBorderStyle(isRevealed: true, isEliminated: false)
        } else {
            imageView.alpha = 1.0
            imageView.image = UIImage(named: "beimian")
            updateBorderStyle(isRevealed: false, isEliminated: false)
        }
        
        // Update layers frame
        DispatchQueue.main.async { [weak self] in
            self?.updateLayersFrame()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removePulsingAnimation()
        imageView.image = nil
        imageView.alpha = 1.0
    }
}

