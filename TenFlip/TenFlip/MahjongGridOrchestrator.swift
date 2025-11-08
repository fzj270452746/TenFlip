//
//  MahjongGridOrchestrator.swift
//  TenFlip
//
//  Collection View Management Component
//

import UIKit

// MARK: - Delegate Protocol

protocol MahjongGridDelegate: AnyObject {
    func gridDidSelectCard(at index: Int, isUpperGrid: Bool)
}

// MARK: - Data Source Protocol

protocol GridDataSource {
    var cardEntities: [MysticTileEntity] { get set }
    var gridDimensionality: Int { get set }
    func numberOfItems() -> Int
    func cardEntity(at index: Int) -> MysticTileEntity?
}

class StandardGridDataSource: GridDataSource {
    var cardEntities: [MysticTileEntity] = []
    var gridDimensionality: Int = 4
    
    func numberOfItems() -> Int {
        return cardEntities.count
    }
    
    func cardEntity(at index: Int) -> MysticTileEntity? {
        guard index >= 0 && index < cardEntities.count else { return nil }
        return cardEntities[index]
    }
}

// MARK: - Cell Configuration Strategy

protocol CellConfigurationStrategy {
    func configure(cell: MahjongCellArchetype, with entity: MysticTileEntity)
}

class StandardCellConfigurationStrategy: CellConfigurationStrategy {
    func configure(cell: MahjongCellArchetype, with entity: MysticTileEntity) {
        cell.configureWithCard(entity)
    }
}

// MARK: - Layout Calculator

protocol LayoutCalculator {
    func calculateCellSize(for collectionView: UICollectionView, dimension: Int) -> CGSize
}

class StandardLayoutCalculator: LayoutCalculator {
    func calculateCellSize(for collectionView: UICollectionView, dimension: Int) -> CGSize {
        let spacing = ArcaneConfiguration.LayoutMetrics.gridSpacing
        let totalSpacing = spacing * CGFloat(dimension - 1)
        
        let availableWidth = collectionView.bounds.width - totalSpacing
        let availableHeight = collectionView.bounds.height - totalSpacing
        
        let cellSizeByWidth = availableWidth / CGFloat(dimension)
        let cellSizeByHeight = availableHeight / CGFloat(dimension)
        
        return CGSize(width: min(cellSizeByWidth, cellSizeByHeight), 
                     height: min(cellSizeByWidth, cellSizeByHeight))
    }
}

// MARK: - Collection View Manager

protocol CollectionViewManager {
    func registerCells(in collectionView: UICollectionView)
    func reloadData(in collectionView: UICollectionView?)
}

class StandardCollectionViewManager: CollectionViewManager {
    private let cellIdentifier: String
    
    init(cellIdentifier: String = "MahjongCellArchetype") {
        self.cellIdentifier = cellIdentifier
    }
    
    func registerCells(in collectionView: UICollectionView) {
        collectionView.register(MahjongCellArchetype.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func reloadData(in collectionView: UICollectionView?) {
        collectionView?.reloadData()
    }
}

// MARK: - Orchestrator Implementation

class MahjongGridOrchestrator: NSObject {
    
    private weak var collectionView: UICollectionView?
    private let gridIdentifier: String
    private let isUpperGrid: Bool
    private let resourceProvider: ArcaneResourceProvider
    weak var delegate: MahjongGridDelegate?
    
    private var dataSource: GridDataSource
    private let cellConfigurationStrategy: CellConfigurationStrategy
    private let layoutCalculator: LayoutCalculator
    private let collectionViewManager: CollectionViewManager
    
    init(collectionView: UICollectionView, 
         identifier: String, 
         isUpperGrid: Bool, 
         resourceProvider: ArcaneResourceProvider = StandardResourceProvider(),
         dataSource: GridDataSource = StandardGridDataSource(),
         cellConfigurationStrategy: CellConfigurationStrategy = StandardCellConfigurationStrategy(),
         layoutCalculator: LayoutCalculator = StandardLayoutCalculator(),
         collectionViewManager: CollectionViewManager = StandardCollectionViewManager()) {
        self.collectionView = collectionView
        self.gridIdentifier = identifier
        self.isUpperGrid = isUpperGrid
        self.resourceProvider = resourceProvider
        self.dataSource = dataSource
        self.cellConfigurationStrategy = cellConfigurationStrategy
        self.layoutCalculator = layoutCalculator
        self.collectionViewManager = collectionViewManager
        super.init()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewManager.registerCells(in: collectionView)
    }
    
    func reconfigureWithEntities(_ entities: [MysticTileEntity], dimension: Int) {
        dataSource.cardEntities = entities
        dataSource.gridDimensionality = dimension
        collectionViewManager.reloadData(in: collectionView)
    }
    
    func refreshPresentation() {
        collectionViewManager.reloadData(in: collectionView)
    }
}

// MARK: - UICollectionViewDataSource Implementation

extension MahjongGridOrchestrator: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MahjongCellArchetype", for: indexPath) as! MahjongCellArchetype
        
        if let entity = dataSource.cardEntity(at: indexPath.item) {
            cellConfigurationStrategy.configure(cell: cell, with: entity)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate Implementation

extension MahjongGridOrchestrator: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.gridDidSelectCard(at: indexPath.item, isUpperGrid: isUpperGrid)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Implementation

extension MahjongGridOrchestrator: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layoutCalculator.calculateCellSize(for: collectionView, dimension: dataSource.gridDimensionality)
    }
}
