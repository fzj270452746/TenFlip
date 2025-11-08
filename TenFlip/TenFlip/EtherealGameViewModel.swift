//
//  EtherealGameViewModel.swift
//  TenFlip
//
//  Game View Model Layer
//

import Foundation

// MARK: - Observer Protocol

protocol EtherealGameStateObserver: AnyObject {
    func chronicleDidAdvance(to level: Int)
    func temporalFluxUpdated(remaining: Int)
    func cardSelectionDidChange()
    func triumphAchieved()
    func catastrophicFailure()
    func pairWasEliminated()
}

// MARK: - Timer Protocol

protocol TemporalEngineProtocol {
    func start(interval: TimeInterval, handler: @escaping () -> Void)
    func stop()
}

class StandardTemporalEngine: TemporalEngineProtocol {
    private var timer: Timer?
    
    func start(interval: TimeInterval, handler: @escaping () -> Void) {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            handler()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Command Pattern

protocol GameCommand {
    func execute()
}

class CardSelectionCommand: GameCommand {
    private weak var session: EphemeralGameSession?
    private let index: Int
    private let isUpper: Bool
    private weak var observer: EtherealGameStateObserver?
    
    init(session: EphemeralGameSession, index: Int, isUpper: Bool, observer: EtherealGameStateObserver?) {
        self.session = session
        self.index = index
        self.isUpper = isUpper
        self.observer = observer
    }
    
    func execute() {
        guard let session = session else { return }
        let entities = isUpper ? session.upperGridCards : session.lowerGridCards
        guard index < entities.count else { return }
        
        let targetEntity = entities[index]
        
        guard !targetEntity.isEliminated else { return }
        guard session.selectedFromUpper == nil || session.selectedFromLower == nil else { return }
        
        if isUpper {
            guard session.selectedFromUpper == nil else { return }
            targetEntity.isRevealed = true
            session.selectedFromUpper = targetEntity
        } else {
            guard session.selectedFromLower == nil else { return }
            targetEntity.isRevealed = true
            session.selectedFromLower = targetEntity
        }
        
        observer?.cardSelectionDidChange()
    }
}

// MARK: - Match Evaluation Strategy

protocol MatchEvaluationStrategy {
    func evaluate(upper: MysticTileEntity, lower: MysticTileEntity) -> Bool
    func getSum(upper: MysticTileEntity, lower: MysticTileEntity) -> Int
}

class StandardMatchEvaluationStrategy: MatchEvaluationStrategy {
    func evaluate(upper: MysticTileEntity, lower: MysticTileEntity) -> Bool {
        return getSum(upper: upper, lower: lower) == 10
    }
    
    func getSum(upper: MysticTileEntity, lower: MysticTileEntity) -> Int {
        return upper.cardType.displayValue + lower.cardType.displayValue
    }
}

// MARK: - State Manager

protocol GameStateManager {
    func checkVictoryCondition(session: EphemeralGameSession) -> Bool
    func processMatchResult(isMatch: Bool, upper: MysticTileEntity, lower: MysticTileEntity, session: EphemeralGameSession)
}

class StandardGameStateManager: GameStateManager {
    func checkVictoryCondition(session: EphemeralGameSession) -> Bool {
        let upperComplete = session.upperGridCards.allSatisfy { $0.isEliminated }
        let lowerComplete = session.lowerGridCards.allSatisfy { $0.isEliminated }
        return upperComplete && lowerComplete
    }
    
    func processMatchResult(isMatch: Bool, upper: MysticTileEntity, lower: MysticTileEntity, session: EphemeralGameSession) {
        if isMatch {
            upper.isEliminated = true
            lower.isEliminated = true
            session.selectedFromUpper = nil
            session.selectedFromLower = nil
            session.remainingTime += ArcaneConfiguration.GameParameters.timeBonus
        } else {
            upper.isRevealed = false
            lower.isRevealed = false
            session.selectedFromUpper = nil
            session.selectedFromLower = nil
        }
    }
}

// MARK: - ViewModel Implementation

class EtherealGameViewModel {
    
    private(set) var arcaneSession: EphemeralGameSession
    weak var stateObserver: EtherealGameStateObserver?
    
    private let temporalEngine: TemporalEngineProtocol
    private let matchStrategy: MatchEvaluationStrategy
    private let stateManager: GameStateManager
    
    init(difficulty: ZenithDifficulty,
         temporalEngine: TemporalEngineProtocol = StandardTemporalEngine(),
         matchStrategy: MatchEvaluationStrategy = StandardMatchEvaluationStrategy(),
         stateManager: GameStateManager = StandardGameStateManager()) {
        self.arcaneSession = EphemeralGameSession(difficulty: difficulty)
        self.temporalEngine = temporalEngine
        self.matchStrategy = matchStrategy
        self.stateManager = stateManager
    }
    
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
    
    func commenceNewChallenge() {
        arcaneSession.generateNewLevel()
        arcaneSession.gamePhase = .commenced
        stateObserver?.chronicleDidAdvance(to: arcaneSession.currentLevel)
        initiateTemporalDecrement()
    }
    
    private func initiateTemporalDecrement() {
        temporalEngine.start(interval: 1.0) { [weak self] in
            self?.processTemporalTick()
        }
    }
    
    func haltTemporalEngine() {
        temporalEngine.stop()
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
        let command = CardSelectionCommand(
            session: arcaneSession,
            index: index,
            isUpper: fromUpper,
            observer: stateObserver
        )
        command.execute()
        
        if let upper = arcaneSession.selectedFromUpper, let lower = arcaneSession.selectedFromLower {
            scheduleMatchEvaluation(upper: upper, lower: lower)
        }
        
        return true
    }
    
    private func scheduleMatchEvaluation(upper: MysticTileEntity, lower: MysticTileEntity) {
        let delay = ArcaneConfiguration.AnimationDurations.matchDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            self.evaluateMatchAttempt(upper: upper, lower: lower)
        }
    }
    
    private func evaluateMatchAttempt(upper: MysticTileEntity, lower: MysticTileEntity) {
        let isMatch = matchStrategy.evaluate(upper: upper, lower: lower)
        stateManager.processMatchResult(
            isMatch: isMatch,
            upper: upper,
            lower: lower,
            session: arcaneSession
        )
        
        if isMatch {
            stateObserver?.pairWasEliminated()
            verifyVictoryCondition()
        } else {
            stateObserver?.cardSelectionDidChange()
        }
    }
    
    private func verifyVictoryCondition() {
        if stateManager.checkVictoryCondition(session: arcaneSession) {
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
        guard arcaneSession.currentLevel > 1 else { return }
        let chronicle = PinnacleRecord(
            difficulty: arcaneSession.difficulty,
            achievedLevel: arcaneSession.currentLevel,
            timestamp: Date()
        )
        AncientVaultKeeper.shared.savePinnacleRecord(chronicle)
    }
}
