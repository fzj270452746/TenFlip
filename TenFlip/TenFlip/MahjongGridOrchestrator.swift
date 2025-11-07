//
//  MahjongGridOrchestrator.swift
//  TenFlip
//
//  Collection View Management Component
//

import UIKit

protocol MahjongGridDelegate: AnyObject {
    func gridDidSelectCard(at index: Int, isUpperGrid: Bool)
}

class MahjongGridOrchestrator: NSObject {
    
    private weak var collectionView: UICollectionView?
    private let gridIdentifier: String
    private let isUpperGrid: Bool
    private let resourceProvider: ArcaneResourceProvider
    weak var delegate: MahjongGridDelegate?
    
    private var cardEntities: [MysticTileEntity] = []
    private var gridDimensionality: Int = 4
    
    init(collectionView: UICollectionView, identifier: String, isUpperGrid: Bool, resourceProvider: ArcaneResourceProvider = StandardResourceProvider()) {
        self.collectionView = collectionView
        self.gridIdentifier = identifier
        self.isUpperGrid = isUpperGrid
        self.resourceProvider = resourceProvider
        super.init()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MahjongCellArchetype.self, forCellWithReuseIdentifier: "MahjongCellArchetype")
    }
    
    func reconfigureWithEntities(_ entities: [MysticTileEntity], dimension: Int) {
        self.cardEntities = entities
        self.gridDimensionality = dimension
        collectionView?.reloadData()
    }
    
    func refreshPresentation() {
        collectionView?.reloadData()
    }
}

extension MahjongGridOrchestrator: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MahjongCellArchetype", for: indexPath) as! MahjongCellArchetype
        
        if indexPath.item < cardEntities.count {
            let entity = cardEntities[indexPath.item]
            cell.configureWithCard(entity)
        }
        
        return cell
    }
}

extension MahjongGridOrchestrator: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.gridDidSelectCard(at: indexPath.item, isUpperGrid: isUpperGrid)
    }
}

extension MahjongGridOrchestrator: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = ArcaneConfiguration.LayoutMetrics.gridSpacing
        let totalSpacing = spacing * CGFloat(gridDimensionality - 1)
        
        let availableWidth = collectionView.bounds.width - totalSpacing
        let availableHeight = collectionView.bounds.height - totalSpacing
        
        let cellSizeByWidth = availableWidth / CGFloat(gridDimensionality)
        let cellSizeByHeight = availableHeight / CGFloat(gridDimensionality)
        let cellSize = min(cellSizeByWidth, cellSizeByHeight)
        
        return CGSize(width: cellSize, height: cellSize)
    }
}

