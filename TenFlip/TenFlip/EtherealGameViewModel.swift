//
//  EtherealGameViewModel.swift
//  TenFlip
//
//  Game View Model Layer
//

import Foundation

protocol EtherealGameStateObserver: AnyObject {
    func chronicleDidAdvance(to level: Int)
    func temporalFluxUpdated(remaining: Int)
    func cardSelectionDidChange()
    func triumphAchieved()
    func catastrophicFailure()
    func pairWasEliminated()
}

class EtherealGameViewModel {
    
    private(set) var arcaneSession: EphemeralGameSession
    weak var stateObserver: EtherealGameStateObserver?
    private var temporalEngine: Timer?
    
    var currentDifficulty: ZenithDifficulty {
        return arcaneSession.difficulty
    }
    
    var currentLevel: Int {
        return arcaneSession.currentLevel
    }
    
    var remainingTime: Int {
        return arcaneSession.remainingTime
    }
    
    var upperGridEntities: [MysticTileEntity] {
        return arcaneSession.upperGridCards
    }
    
    var lowerGridEntities: [MysticTileEntity] {
        return arcaneSession.lowerGridCards
    }
    
    init(difficulty: ZenithDifficulty) {
        self.arcaneSession = EphemeralGameSession(difficulty: difficulty)
    }
    
    func commenceNewChallenge() {
        arcaneSession.generateNewLevel()
        arcaneSession.gamePhase = .commenced
        stateObserver?.chronicleDidAdvance(to: arcaneSession.currentLevel)
        initiateTemporalDecrement()
    }
    
    private func initiateTemporalDecrement() {
        temporalEngine?.invalidate()
        temporalEngine = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.processTemporalTick()
        }
    }
    
    func haltTemporalEngine() {
        temporalEngine?.invalidate()
        temporalEngine = nil
    }
    
    private func processTemporalTick() {
        arcaneSession.remainingTime -= 1
        stateObserver?.temporalFluxUpdated(remaining: arcaneSession.remainingTime)
        
        if arcaneSession.remainingTime <= 0 {
            haltTemporalEngine()
            arcaneSession.gamePhase = .vanquished
            stateObserver?.catastrophicFailure()
        }
    }
    
    func attemptCardSelection(at index: Int, fromUpper: Bool) -> Bool {
        let entities = fromUpper ? arcaneSession.upperGridCards : arcaneSession.lowerGridCards
        guard index < entities.count else { return false }
        
        let targetEntity = entities[index]
        
        if targetEntity.isEliminated {
            return false
        }
        
        if arcaneSession.selectedFromUpper != nil && arcaneSession.selectedFromLower != nil {
            return false
        }
        
        if fromUpper {
            if arcaneSession.selectedFromUpper != nil {
                return false
            }
            targetEntity.isRevealed = true
            arcaneSession.selectedFromUpper = targetEntity
        } else {
            if arcaneSession.selectedFromLower != nil {
                return false
            }
            targetEntity.isRevealed = true
            arcaneSession.selectedFromLower = targetEntity
        }
        
        stateObserver?.cardSelectionDidChange()
        
        if let upper = arcaneSession.selectedFromUpper, let lower = arcaneSession.selectedFromLower {
            evaluateMatchAttempt(upper: upper, lower: lower)
        }
        
        return true
    }
    
    private func evaluateMatchAttempt(upper: MysticTileEntity, lower: MysticTileEntity) {
        let summation = upper.cardType.displayValue + lower.cardType.displayValue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + ArcaneConfiguration.AnimationDurations.matchDelay) { [weak self] in
            guard let self = self else { return }
            
            if summation == 10 {
                upper.isEliminated = true
                lower.isEliminated = true
                self.arcaneSession.selectedFromUpper = nil
                self.arcaneSession.selectedFromLower = nil
                self.arcaneSession.remainingTime += ArcaneConfiguration.GameParameters.timeBonus
                self.stateObserver?.pairWasEliminated()
                self.verifyVictoryCondition()
            } else {
                upper.isRevealed = false
                lower.isRevealed = false
                self.arcaneSession.selectedFromUpper = nil
                self.arcaneSession.selectedFromLower = nil
                self.stateObserver?.cardSelectionDidChange()
            }
        }
    }
    
    private func verifyVictoryCondition() {
        let allVanquished = arcaneSession.upperGridCards.allSatisfy { $0.isEliminated } &&
                           arcaneSession.lowerGridCards.allSatisfy { $0.isEliminated }
        
        if allVanquished {
            haltTemporalEngine()
            stateObserver?.triumphAchieved()
        }
    }
    
    func progressToNextLevel() {
        arcaneSession.currentLevel += 1
        commenceNewChallenge()
    }
    
    func resetToInitialState() {
        arcaneSession.currentLevel = 1
        commenceNewChallenge()
    }
    
    func preserveAchievement() {
        if arcaneSession.currentLevel > 1 {
            let chronicle = PinnacleRecord(
                difficulty: arcaneSession.difficulty,
                achievedLevel: arcaneSession.currentLevel,
                timestamp: Date()
            )
            AncientVaultKeeper.shared.savePinnacleRecord(chronicle)
        }
    }
}

