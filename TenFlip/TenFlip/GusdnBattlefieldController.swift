

import UIKit

class GusdnBattlefieldController: UIViewController {
    
    private var viewModel: EtherealGameViewModel
    private var upperGridOrchestrator: MahjongGridOrchestrator!
    private var lowerGridOrchestrator: MahjongGridOrchestrator!
    private let resourceProvider = StandardResourceProvider()
    
    private lazy var backgroundLayer: UIImageView = {
        let iv = UIImageView()
        iv.image = resourceProvider.obtainBackgroundTexture()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var dimmerOverlay: UIView = {
        let v = UIView()
        v.backgroundColor = ArcaneConfiguration.ColorPalette.overlayUmber
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var retreatButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("← Back", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(initiateRetreat), for: .touchUpInside)
        return btn
    }()
    
    private lazy var levelBanner: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 1, height: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var chronometer: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 1, height: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var upperCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = ArcaneConfiguration.LayoutMetrics.gridSpacing
        layout.minimumLineSpacing = ArcaneConfiguration.LayoutMetrics.gridSpacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var lowerCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = ArcaneConfiguration.LayoutMetrics.gridSpacing
        layout.minimumLineSpacing = ArcaneConfiguration.LayoutMetrics.gridSpacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var dividerLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    init(difficulty: ZenithDifficulty) {
        self.viewModel = EtherealGameViewModel(difficulty: difficulty)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembleInterface()
        establishOrchestrators()
        viewModel.stateObserver = self
        viewModel.commenceNewChallenge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.haltTemporalEngine()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func assembleInterface() {
        view.addSubview(backgroundLayer)
        view.addSubview(dimmerOverlay)
        view.addSubview(retreatButton)
        view.addSubview(levelBanner)
        view.addSubview(chronometer)
        view.addSubview(upperCollection)
        view.addSubview(dividerLine)
        view.addSubview(lowerCollection)
        
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        let topSpace: CGFloat = 90
        let separatorSpace: CGFloat = 8
        let bottomSpace: CGFloat = 30
        let availableHeight = viewHeight - topSpace - separatorSpace - bottomSpace
        let singleGridHeight = availableHeight / 2 - 20
        let availableWidth = viewWidth - 32
        let gridSize = min(availableWidth, singleGridHeight)
        
        NSLayoutConstraint.activate([
            backgroundLayer.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dimmerOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            dimmerOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmerOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmerOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            retreatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            retreatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            levelBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            levelBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            levelBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            chronometer.topAnchor.constraint(equalTo: levelBanner.bottomAnchor, constant: 4),
            chronometer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chronometer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            upperCollection.topAnchor.constraint(equalTo: chronometer.bottomAnchor, constant: 8),
            upperCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            upperCollection.widthAnchor.constraint(equalToConstant: gridSize),
            upperCollection.heightAnchor.constraint(equalToConstant: gridSize),
            
            dividerLine.topAnchor.constraint(equalTo: upperCollection.bottomAnchor, constant: 4),
            dividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            dividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            dividerLine.heightAnchor.constraint(equalToConstant: 2),
            
            lowerCollection.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 4),
            lowerCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lowerCollection.widthAnchor.constraint(equalToConstant: gridSize),
            lowerCollection.heightAnchor.constraint(equalToConstant: gridSize)
        ])
    }
    
    private func establishOrchestrators() {
        upperGridOrchestrator = MahjongGridOrchestrator(
            collectionView: upperCollection,
            identifier: "upper",
            isUpperGrid: true,
            resourceProvider: resourceProvider
        )
        upperGridOrchestrator.delegate = self
        
        lowerGridOrchestrator = MahjongGridOrchestrator(
            collectionView: lowerCollection,
            identifier: "lower",
            isUpperGrid: false,
            resourceProvider: resourceProvider
        )
        lowerGridOrchestrator.delegate = self
    }
    
    private func synchronizeInterface() {
        levelBanner.text = "Level \(viewModel.currentLevel)"
        chronometer.text = "Time: \(viewModel.remainingTime)s"
        
        upperGridOrchestrator.reconfigureWithEntities(
            viewModel.upperGridEntities,
            dimension: viewModel.currentDifficulty.gridDimension
        )
        
        lowerGridOrchestrator.reconfigureWithEntities(
            viewModel.lowerGridEntities,
            dimension: viewModel.currentDifficulty.gridDimension
        )
    }
    
    @objc private func initiateRetreat() {
        viewModel.haltTemporalEngine()
        
        let portal = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Yes", style: .destructive) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            DialogAction(title: "No", style: .secondary, handler: nil)
        ]
        portal.manifestWithConfiguration(
            title: "Quit Game",
            message: "Are you sure you want to quit the game?",
            actions: actions
        )
    }
    
    private func presentTriumphDialog() {
        let portal = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Next Level", style: .primary) { [weak self] in
                self?.viewModel.progressToNextLevel()
            },
            DialogAction(title: "Quit", style: .secondary) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        ]
        portal.manifestWithConfiguration(
            title: "Level Complete!",
            message: "Congratulations! You've cleared Level \(viewModel.currentLevel)!",
            actions: actions
        )
    }
    
    private func presentFailureDialog() {
        viewModel.preserveAchievement()
        
        let portal = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "Try Again", style: .primary) { [weak self] in
                self?.viewModel.resetToInitialState()
            },
            DialogAction(title: "Quit", style: .secondary) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        ]
        
        let message = viewModel.currentLevel > 1 ?
            "You reached Level \(viewModel.currentLevel)!\nYour score has been saved." :
            "Time's up! Try again to reach higher levels."
        
        portal.manifestWithConfiguration(
            title: "Game Over",
            message: message,
            actions: actions
        )
    }
}

extension GusdnBattlefieldController: EtherealGameStateObserver {
    
    func chronicleDidAdvance(to level: Int) {
        synchronizeInterface()
    }
    
    func temporalFluxUpdated(remaining: Int) {
        chronometer.text = "Time: \(remaining)s"
        
        if remaining <= 10 {
            chronometer.textColor = .red
        } else {
            chronometer.textColor = .white
        }
    }
    
    func cardSelectionDidChange() {
        upperGridOrchestrator.refreshPresentation()
        lowerGridOrchestrator.refreshPresentation()
    }
    
    func triumphAchieved() {
        presentTriumphDialog()
    }
    
    func catastrophicFailure() {
        presentFailureDialog()
    }
    
    func pairWasEliminated() {
        chronometer.textColor = ArcaneConfiguration.ColorPalette.successVerdant
        
        upperGridOrchestrator.refreshPresentation()
        lowerGridOrchestrator.refreshPresentation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + ArcaneConfiguration.AnimationDurations.colorFlash) { [weak self] in
            guard let self = self else { return }
            if self.viewModel.remainingTime > 10 {
                self.chronometer.textColor = .white
            }
        }
    }
}

extension GusdnBattlefieldController: MahjongGridDelegate {
    
    func gridDidSelectCard(at index: Int, isUpperGrid: Bool) {
        _ = viewModel.attemptCardSelection(at: index, fromUpper: isUpperGrid)
    }
}

