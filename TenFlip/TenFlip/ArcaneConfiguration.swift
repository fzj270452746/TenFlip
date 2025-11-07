
import UIKit

struct ArcaneConfiguration {
    
    struct ColorPalette {
        static let primaryBronze = UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0)
        static let secondaryAqua = UIColor(red: 0.3, green: 0.6, blue: 0.8, alpha: 1.0)
        static let tertiaryEmerald = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0)
        static let quaternaryViolet = UIColor(red: 0.7, green: 0.5, blue: 0.8, alpha: 1.0)
        static let warningCrimson = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        static let successVerdant = UIColor(red: 0.2, green: 1.0, blue: 0.4, alpha: 1.0)
        static let neutralIvory = UIColor(red: 0.95, green: 0.93, blue: 0.88, alpha: 1.0)
        static let shadowObsidian = UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 1.0)
        static let overlayUmber = UIColor.black.withAlphaComponent(0.4)
        static let dimGray = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
    }
    
    struct LayoutMetrics {
        static let gridSpacing: CGFloat = 4
        static let cornerRadius: CGFloat = 12
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 6
        static let shadowOffset = CGSize(width: 0, height: 4)
        static let buttonHeight: CGFloat = 50
        static let standardPadding: CGFloat = 20
    }
    
    struct AnimationDurations {
        static let matchDelay: TimeInterval = 0.5
        static let colorFlash: TimeInterval = 0.3
        static let dialogAppear: TimeInterval = 0.3
        static let dialogDismiss: TimeInterval = 0.2
    }
    
    struct GameParameters {
        static let timeBonus: Int = 5
        static let leaderboardLimit: Int = 10
    }
}

protocol ArcaneResourceProvider {
    func obtainBackgroundTexture() -> UIImage?
    func obtainCardTexture(for identifier: String) -> UIImage?
    func obtainReverseTexture() -> UIImage?
}

class StandardResourceProvider: ArcaneResourceProvider {
    func obtainBackgroundTexture() -> UIImage? {
        return UIImage(named: "tenflip")
    }
    
    func obtainCardTexture(for identifier: String) -> UIImage? {
        return UIImage(named: identifier)
    }
    
    func obtainReverseTexture() -> UIImage? {
        return UIImage(named: "beimian")
    }
}

