//
//  VerdantArchetype.swift
//  TenFlip
//
//  Game Models and Data Structures
//

import Foundation

// MARK: - Difficulty Mode
enum ZenithDifficulty: String, Codable {
    case novice = "Simple"
    case arduous = "Difficult"
    
    var gridDimension: Int {
        switch self {
        case .novice: return 4
        case .arduous: return 5
        }
    }
    
    var temporalAllowance: Int {
        switch self {
        case .novice: return 40
        case .arduous: return 60
        }
    }
    
    var totalCellCount: Int {
        return gridDimension * gridDimension
    }
}

// MARK: - Mahjong Suit Type
enum EtherealSuit: String, CaseIterable {
    case ndhuu
    case tersg
    case koden
}

// MARK: - Card Type
enum CelestialCardType {
    case numericGlyph(Int)
    case mahjongTile(suit: EtherealSuit, value: Int)
    
    var displayValue: Int {
        switch self {
        case .numericGlyph(let val):
            return val
        case .mahjongTile(_, let val):
            return val
        }
    }
    
    var imageName: String {
        switch self {
        case .numericGlyph(let val):
            return "number\(val)"
        case .mahjongTile(let suit, let val):
            return "\(suit.rawValue)\(val)"
        }
    }
}

// MARK: - Card Model
class MysticTileEntity {
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
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

// MARK: - Game Session
class EphemeralGameSession {
    var difficulty: ZenithDifficulty
    var currentLevel: Int = 1
    var upperGridCards: [MysticTileEntity] = []
    var lowerGridCards: [MysticTileEntity] = []
    var remainingTime: Int
    var selectedFromUpper: MysticTileEntity?
    var selectedFromLower: MysticTileEntity?
    var gamePhase: ObscureGamePhase = .pristine
    
    init(difficulty: ZenithDifficulty) {
        self.difficulty = difficulty
        self.remainingTime = difficulty.temporalAllowance
    }
    
    func generateNewLevel() {
        upperGridCards.removeAll()
        lowerGridCards.removeAll()
        selectedFromUpper = nil
        selectedFromLower = nil
        remainingTime = difficulty.temporalAllowance
        
        let totalCells = difficulty.totalCellCount
        var availableValues: [Int] = []
        
        // Generate matching pairs that sum to 10
        var pairsNeeded = totalCells
        while pairsNeeded > 0 {
            let value = Int.random(in: 1...9)
            let complement = 10 - value
            if complement >= 1 && complement <= 9 {
                availableValues.append(value)
                availableValues.append(complement)
                pairsNeeded -= 2
            }
        }
        
        availableValues.shuffle()
        
        // Create upper grid with numeric glyphs
        for i in 0..<totalCells {
            let value = availableValues[i]
            let card = MysticTileEntity(
                identifier: UUID().uuidString,
                cardType: .numericGlyph(value),
                gridPosition: i
            )
            upperGridCards.append(card)
        }
        
        // Create lower grid with mahjong tiles (matching complements)
        for i in 0..<totalCells {
            let upperValue = availableValues[i]
            let complementValue = 10 - upperValue
            let randomSuit = EtherealSuit.allCases.randomElement()!
            let card = MysticTileEntity(
                identifier: UUID().uuidString,
                cardType: .mahjongTile(suit: randomSuit, value: complementValue),
                gridPosition: i
            )
            lowerGridCards.append(card)
        }
        
        // Shuffle lower grid
        lowerGridCards.shuffle()
        for (index, card) in lowerGridCards.enumerated() {
            card.gridPosition = index
        }
    }
}

// MARK: - Persistent Storage Manager
class AncientVaultKeeper {
    static let shared = AncientVaultKeeper()
    private let pinnacleRecordsKey = "nebulous_pinnacle_records"
    private let feedbackRepositoryKey = "ethereal_feedback_repository"
    
    private init() {}
    
    func savePinnacleRecord(_ record: PinnacleRecord) {
        var records = fetchPinnacleRecords()
        records.append(record)
        records.sort { $0.achievedLevel > $1.achievedLevel }
        
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: pinnacleRecordsKey)
        }
    }
    
    func fetchPinnacleRecords() -> [PinnacleRecord] {
        guard let data = UserDefaults.standard.data(forKey: pinnacleRecordsKey),
              let records = try? JSONDecoder().decode([PinnacleRecord].self, from: data) else {
            return []
        }
        return records
    }
    
    func fetchRecordsForDifficulty(_ difficulty: ZenithDifficulty) -> [PinnacleRecord] {
        return fetchPinnacleRecords().filter { $0.difficulty == difficulty }
            .sorted { $0.achievedLevel > $1.achievedLevel }
    }
    
    func saveFeedbackEntry(_ feedback: String) {
        var feedbackList = fetchFeedbackEntries()
        let entry = ["content": feedback, "timestamp": Date().timeIntervalSince1970] as [String : Any]
        feedbackList.append(entry)
        UserDefaults.standard.set(feedbackList, forKey: feedbackRepositoryKey)
    }
    
    func fetchFeedbackEntries() -> [[String: Any]] {
        return UserDefaults.standard.array(forKey: feedbackRepositoryKey) as? [[String: Any]] ?? []
    }
}

