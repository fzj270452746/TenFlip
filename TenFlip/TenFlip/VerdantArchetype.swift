//
//  VerdantArchetype.swift
//  TenFlip
//
//  Game Models and Data Structures
//

import Foundation

// MARK: - Protocol-Based Architecture

protocol DifficultyConfiguration {
    var gridDimension: Int { get }
    var temporalAllowance: Int { get }
    var totalCellCount: Int { get }
}

protocol CardValueProvider {
    var displayValue: Int { get }
    var imageName: String { get }
}

protocol CardStateManager {
    var isRevealed: Bool { get set }
    var isEliminated: Bool { get set }
}

protocol GridPositionProvider {
    var gridPosition: Int { get set }
}

protocol IdentifiableEntity {
    var identifier: String { get }
}

// MARK: - Difficulty Mode Implementation

enum ZenithDifficulty: String, Codable {
    case novice = "Simple"
    case arduous = "Difficult"
    
    private struct Configuration: DifficultyConfiguration {
        let gridDimension: Int
        let temporalAllowance: Int
        var totalCellCount: Int { gridDimension * gridDimension }
    }
    
    private var configuration: Configuration {
        switch self {
        case .novice:
            return Configuration(gridDimension: 4, temporalAllowance: 40)
        case .arduous:
            return Configuration(gridDimension: 5, temporalAllowance: 60)
        }
    }
    
    var gridDimension: Int { configuration.gridDimension }
    var temporalAllowance: Int { configuration.temporalAllowance }
    var totalCellCount: Int { configuration.totalCellCount }
}

// MARK: - Mahjong Suit Type

enum EtherealSuit: String, CaseIterable {
    case ndhuu
    case tersg
    case koden
    
    static func randomSelection() -> EtherealSuit {
        return allCases[Int.random(in: 0..<allCases.count)]
    }
}

// MARK: - Card Type Implementation

enum CelestialCardType {
    case numericGlyph(Int)
    case mahjongTile(suit: EtherealSuit, value: Int)
    
    private struct ValueExtractor: CardValueProvider {
        let cardType: CelestialCardType
        
        var displayValue: Int {
            switch cardType {
            case .numericGlyph(let val):
                return val
            case .mahjongTile(_, let val):
                return val
            }
        }
        
        var imageName: String {
            switch cardType {
            case .numericGlyph(let val):
                return "number\(val)"
            case .mahjongTile(let suit, let val):
                return "\(suit.rawValue)\(val)"
            }
        }
    }
    
    private var extractor: ValueExtractor {
        ValueExtractor(cardType: self)
    }
    
    var displayValue: Int { extractor.displayValue }
    var imageName: String { extractor.imageName }
}

// MARK: - Card Model Implementation

class MysticTileEntity: IdentifiableEntity, CardStateManager, GridPositionProvider {
    let identifier: String
    let cardType: CelestialCardType
    var isRevealed: Bool = false
    var isEliminated: Bool = false
    var gridPosition: Int
    
    init(identifier: String, cardType: CelestialCardType, gridPosition: Int) {
        self.identifier = identifier
        self.cardType = cardType
        self.gridPosition = gridPosition
    }
}

// MARK: - Game State

enum ObscureGamePhase {
    case pristine
    case commenced
    case suspended
    case triumph
    case vanquished
}

// MARK: - Leaderboard Entry

struct PinnacleRecord: Codable {
    let difficulty: ZenithDifficulty
    let achievedLevel: Int
    let timestamp: Date
    
    private struct DateFormatterProvider {
        static let shared: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }()
    }
    
    var formattedDate: String {
        DateFormatterProvider.shared.string(from: timestamp)
    }
}

// MARK: - Card Generation Strategy

protocol CardGenerationStrategy {
    func generatePairs(count: Int) -> [(Int, Int)]
}

struct RandomPairGenerationStrategy: CardGenerationStrategy {
    func generatePairs(count: Int) -> [(Int, Int)] {
        // Generate enough pairs to fill all cells
        // If count is odd, we need (count + 1) / 2 pairs, then use only count values
        // If count is even, we need count / 2 pairs
        let pairsNeeded = (count + 1) / 2
        var pairs: [(Int, Int)] = []
        var generatedValues = Set<Int>()
        var attempts = 0
        let maxAttempts = count * 10
        
        while pairs.count < pairsNeeded && attempts < maxAttempts {
            let value = Int.random(in: 1...9)
            let complement = 10 - value
            
            if complement >= 1 && complement <= 9 && !generatedValues.contains(value) {
                pairs.append((value, complement))
                generatedValues.insert(value)
                generatedValues.insert(complement)
            }
            attempts += 1
        }
        
        // Fill remaining if needed
        while pairs.count < pairsNeeded {
            let value = Int.random(in: 1...9)
            let complement = 10 - value
            if complement >= 1 && complement <= 9 {
                pairs.append((value, complement))
            }
        }
        
        return pairs
    }
}

// MARK: - Grid Builder

protocol GridBuilder {
    func buildUpperGrid(pairs: [(Int, Int)]) -> [MysticTileEntity]
    func buildLowerGrid(pairs: [(Int, Int)]) -> [MysticTileEntity]
}

class StandardGridBuilder: GridBuilder {
    private var targetCellCount: Int = 0
    
    func buildUpperGrid(pairs: [(Int, Int)]) -> [MysticTileEntity] {
        var values: [Int] = []
        for (value, complement) in pairs {
            values.append(value)
            values.append(complement)
        }
        
        values.shuffle()
        
        // Store the target count (will be set by the session)
        // If not set, use all available values
        let countToUse = targetCellCount > 0 ? min(targetCellCount, values.count) : values.count
        
        return values.prefix(countToUse).enumerated().map { index, value in
            MysticTileEntity(
                identifier: UUID().uuidString,
                cardType: .numericGlyph(value),
                gridPosition: index
            )
        }
    }
    
    func buildLowerGrid(pairs: [(Int, Int)]) -> [MysticTileEntity] {
        var values: [Int] = []
        for (value, complement) in pairs {
            values.append(value)
            values.append(complement)
        }
        
        // Create complements for all values
        let complements = values.map { 10 - $0 }
        var shuffledComplements = complements.shuffled()
        
        // Use the same count as upper grid
        let countToUse = targetCellCount > 0 ? min(targetCellCount, shuffledComplements.count) : shuffledComplements.count
        
        return shuffledComplements.prefix(countToUse).enumerated().map { index, complementValue in
            MysticTileEntity(
                identifier: UUID().uuidString,
                cardType: .mahjongTile(suit: EtherealSuit.randomSelection(), value: complementValue),
                gridPosition: index
            )
        }
    }
    
    func setTargetCellCount(_ count: Int) {
        targetCellCount = count
    }
}

// MARK: - Game Session Implementation

class EphemeralGameSession {
    var difficulty: ZenithDifficulty
    var currentLevel: Int = 1
    var upperGridCards: [MysticTileEntity] = []
    var lowerGridCards: [MysticTileEntity] = []
    var remainingTime: Int
    var selectedFromUpper: MysticTileEntity?
    var selectedFromLower: MysticTileEntity?
    var gamePhase: ObscureGamePhase = .pristine
    
    private let cardGenerationStrategy: CardGenerationStrategy
    private let gridBuilder: GridBuilder
    
    init(difficulty: ZenithDifficulty, 
         strategy: CardGenerationStrategy = RandomPairGenerationStrategy(),
         builder: GridBuilder = StandardGridBuilder()) {
        self.difficulty = difficulty
        self.remainingTime = difficulty.temporalAllowance
        self.cardGenerationStrategy = strategy
        self.gridBuilder = builder
    }
    
    func generateNewLevel() {
        resetSessionState()
        
        let totalCells = difficulty.totalCellCount
        let pairs = cardGenerationStrategy.generatePairs(count: totalCells)
        
        // Set target count in builder to ensure correct number of cards
        if let standardBuilder = gridBuilder as? StandardGridBuilder {
            standardBuilder.setTargetCellCount(totalCells)
        }
        
        upperGridCards = gridBuilder.buildUpperGrid(pairs: pairs)
        lowerGridCards = gridBuilder.buildLowerGrid(pairs: pairs)
        
        updateLowerGridPositions()
    }
    
    private func resetSessionState() {
        upperGridCards.removeAll()
        lowerGridCards.removeAll()
        selectedFromUpper = nil
        selectedFromLower = nil
        remainingTime = difficulty.temporalAllowance
    }
    
    private func updateLowerGridPositions() {
        lowerGridCards.enumerated().forEach { index, card in
            card.gridPosition = index
        }
    }
}

// MARK: - Storage Protocol

protocol PersistentStorage {
    func savePinnacleRecord(_ record: PinnacleRecord)
    func fetchPinnacleRecords() -> [PinnacleRecord]
    func fetchRecordsForDifficulty(_ difficulty: ZenithDifficulty) -> [PinnacleRecord]
    func saveFeedbackEntry(_ feedback: String)
    func fetchFeedbackEntries() -> [[String: Any]]
}

// MARK: - Persistent Storage Manager Implementation

class AncientVaultKeeper: PersistentStorage {
    static let shared = AncientVaultKeeper()
    private let pinnacleRecordsKey = "nebulous_pinnacle_records"
    private let feedbackRepositoryKey = "ethereal_feedback_repository"
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let userDefaults: UserDefaults
    
    private init(encoder: JSONEncoder = JSONEncoder(),
                 decoder: JSONDecoder = JSONDecoder(),
                 userDefaults: UserDefaults = .standard) {
        self.encoder = encoder
        self.decoder = decoder
        self.userDefaults = userDefaults
    }
    
    func savePinnacleRecord(_ record: PinnacleRecord) {
        var records = fetchPinnacleRecords()
        records.append(record)
        records.sort { $0.achievedLevel > $1.achievedLevel }
        
        guard let encoded = try? encoder.encode(records) else { return }
        userDefaults.set(encoded, forKey: pinnacleRecordsKey)
    }
    
    func fetchPinnacleRecords() -> [PinnacleRecord] {
        guard let data = userDefaults.data(forKey: pinnacleRecordsKey),
              let records = try? decoder.decode([PinnacleRecord].self, from: data) else {
            return []
        }
        return records
    }
    
    func fetchRecordsForDifficulty(_ difficulty: ZenithDifficulty) -> [PinnacleRecord] {
        return fetchPinnacleRecords()
            .filter { $0.difficulty == difficulty }
            .sorted { $0.achievedLevel > $1.achievedLevel }
    }
    
    func saveFeedbackEntry(_ feedback: String) {
        var feedbackList = fetchFeedbackEntries()
        let entry: [String: Any] = [
            "content": feedback,
            "timestamp": Date().timeIntervalSince1970
        ]
        feedbackList.append(entry)
        userDefaults.set(feedbackList, forKey: feedbackRepositoryKey)
    }
    
    func fetchFeedbackEntries() -> [[String: Any]] {
        return userDefaults.array(forKey: feedbackRepositoryKey) as? [[String: Any]] ?? []
    }
}
