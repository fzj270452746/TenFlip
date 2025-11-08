
import UIKit

// MARK: - Color Provider Protocol

protocol ColorProvider {
    var neonPink: UIColor { get }
    var neonCyan: UIColor { get }
    var neonPurple: UIColor { get }
    var neonOrange: UIColor { get }
    var neonGreen: UIColor { get }
    var neonBlue: UIColor { get }
    var gradientStart: UIColor { get }
    var gradientEnd: UIColor { get }
    var startButtonGradientStart: UIColor { get }
    var startButtonGradientEnd: UIColor { get }
    var leaderboardButtonGradientStart: UIColor { get }
    var leaderboardButtonGradientEnd: UIColor { get }
    var rulesButtonGradientStart: UIColor { get }
    var rulesButtonGradientEnd: UIColor { get }
    var feedbackButtonGradientStart: UIColor { get }
    var feedbackButtonGradientEnd: UIColor { get }
    var glassBackground: UIColor { get }
    var glassBorder: UIColor { get }
}

class ModernColorProvider: ColorProvider {
    var neonPink: UIColor { UIColor(red: 1.0, green: 0.2, blue: 0.8, alpha: 1.0) }
    var neonCyan: UIColor { UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0) }
    var neonPurple: UIColor { UIColor(red: 0.6, green: 0.2, blue: 1.0, alpha: 1.0) }
    var neonOrange: UIColor { UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0) }
    var neonGreen: UIColor { UIColor(red: 0.2, green: 1.0, blue: 0.4, alpha: 1.0) }
    var neonBlue: UIColor { UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0) }
    var gradientStart: UIColor { UIColor(red: 0.2, green: 0.0, blue: 0.4, alpha: 1.0) }
    var gradientEnd: UIColor { UIColor(red: 0.0, green: 0.2, blue: 0.4, alpha: 1.0) }
    var startButtonGradientStart: UIColor { UIColor(red: 1.0, green: 0.3, blue: 0.6, alpha: 1.0) }
    var startButtonGradientEnd: UIColor { UIColor(red: 0.8, green: 0.2, blue: 1.0, alpha: 1.0) }
    var leaderboardButtonGradientStart: UIColor { UIColor(red: 0.2, green: 0.8, blue: 1.0, alpha: 1.0) }
    var leaderboardButtonGradientEnd: UIColor { UIColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1.0) }
    var rulesButtonGradientStart: UIColor { UIColor(red: 0.2, green: 1.0, blue: 0.6, alpha: 1.0) }
    var rulesButtonGradientEnd: UIColor { UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0) }
    var feedbackButtonGradientStart: UIColor { UIColor(red: 0.8, green: 0.4, blue: 1.0, alpha: 1.0) }
    var feedbackButtonGradientEnd: UIColor { UIColor(red: 0.6, green: 0.2, blue: 0.9, alpha: 1.0) }
    var glassBackground: UIColor { UIColor.white.withAlphaComponent(0.15) }
    var glassBorder: UIColor { UIColor.white.withAlphaComponent(0.3) }
}

// MARK: - Layout Metrics Provider

protocol LayoutMetricsProvider {
    var gridSpacing: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var shadowOpacity: Float { get }
    var shadowRadius: CGFloat { get }
    var shadowOffset: CGSize { get }
    var buttonHeight: CGFloat { get }
    var standardPadding: CGFloat { get }
    var glassCornerRadius: CGFloat { get }
    var neonGlowRadius: CGFloat { get }
    var neonGlowOpacity: Float { get }
    var buttonWidth: CGFloat { get }
    var largeButtonHeight: CGFloat { get }
    var regularButtonHeight: CGFloat { get }
}

class StandardLayoutMetricsProvider: LayoutMetricsProvider {
    var gridSpacing: CGFloat { 4 }
    var cornerRadius: CGFloat { 12 }
    var shadowOpacity: Float { 0.3 }
    var shadowRadius: CGFloat { 6 }
    var shadowOffset: CGSize { CGSize(width: 0, height: 4) }
    var buttonHeight: CGFloat { 50 }
    var standardPadding: CGFloat { 20 }
    var glassCornerRadius: CGFloat { 20 }
    var neonGlowRadius: CGFloat { 15 }
    var neonGlowOpacity: Float { 0.8 }
    var buttonWidth: CGFloat { 240 }
    var largeButtonHeight: CGFloat { 70 }
    var regularButtonHeight: CGFloat { 60 }
}

// MARK: - Animation Configuration Provider

protocol AnimationConfigurationProvider {
    var matchDelay: TimeInterval { get }
    var colorFlash: TimeInterval { get }
    var dialogAppear: TimeInterval { get }
    var dialogDismiss: TimeInterval { get }
}

class StandardAnimationConfigurationProvider: AnimationConfigurationProvider {
    var matchDelay: TimeInterval { 0.5 }
    var colorFlash: TimeInterval { 0.3 }
    var dialogAppear: TimeInterval { 0.3 }
    var dialogDismiss: TimeInterval { 0.2 }
}

// MARK: - Game Parameters Provider

protocol GameParametersProvider {
    var timeBonus: Int { get }
    var leaderboardLimit: Int { get }
}

class StandardGameParametersProvider: GameParametersProvider {
    var timeBonus: Int { 5 }
    var leaderboardLimit: Int { 10 }
}

// MARK: - Configuration Container

struct ArcaneConfiguration {
    
    static let colorPalette: ColorProvider = ModernColorProvider()
    static let layoutMetrics: LayoutMetricsProvider = StandardLayoutMetricsProvider()
    static let animationDurations: AnimationConfigurationProvider = StandardAnimationConfigurationProvider()
    static let gameParameters: GameParametersProvider = StandardGameParametersProvider()
    
    // Backward compatibility - ColorPalette
    struct ColorPalette {
        static var neonPink: UIColor { ArcaneConfiguration.colorPalette.neonPink }
        static var neonCyan: UIColor { ArcaneConfiguration.colorPalette.neonCyan }
        static var neonPurple: UIColor { ArcaneConfiguration.colorPalette.neonPurple }
        static var neonOrange: UIColor { ArcaneConfiguration.colorPalette.neonOrange }
        static var neonGreen: UIColor { ArcaneConfiguration.colorPalette.neonGreen }
        static var neonBlue: UIColor { ArcaneConfiguration.colorPalette.neonBlue }
        static var gradientStart: UIColor { ArcaneConfiguration.colorPalette.gradientStart }
        static var gradientEnd: UIColor { ArcaneConfiguration.colorPalette.gradientEnd }
        static var startButtonGradientStart: UIColor { ArcaneConfiguration.colorPalette.startButtonGradientStart }
        static var startButtonGradientEnd: UIColor { ArcaneConfiguration.colorPalette.startButtonGradientEnd }
        static var leaderboardButtonGradientStart: UIColor { ArcaneConfiguration.colorPalette.leaderboardButtonGradientStart }
        static var leaderboardButtonGradientEnd: UIColor { ArcaneConfiguration.colorPalette.leaderboardButtonGradientEnd }
        static var rulesButtonGradientStart: UIColor { ArcaneConfiguration.colorPalette.rulesButtonGradientStart }
        static var rulesButtonGradientEnd: UIColor { ArcaneConfiguration.colorPalette.rulesButtonGradientEnd }
        static var feedbackButtonGradientStart: UIColor { ArcaneConfiguration.colorPalette.feedbackButtonGradientStart }
        static var feedbackButtonGradientEnd: UIColor { ArcaneConfiguration.colorPalette.feedbackButtonGradientEnd }
        static var glassBackground: UIColor { ArcaneConfiguration.colorPalette.glassBackground }
        static var glassBorder: UIColor { ArcaneConfiguration.colorPalette.glassBorder }
        
        // Legacy colors
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
    
    // Backward compatibility - LayoutMetrics
    struct LayoutMetrics {
        static var gridSpacing: CGFloat { ArcaneConfiguration.layoutMetrics.gridSpacing }
        static var cornerRadius: CGFloat { ArcaneConfiguration.layoutMetrics.cornerRadius }
        static var shadowOpacity: Float { ArcaneConfiguration.layoutMetrics.shadowOpacity }
        static var shadowRadius: CGFloat { ArcaneConfiguration.layoutMetrics.shadowRadius }
        static var shadowOffset: CGSize { ArcaneConfiguration.layoutMetrics.shadowOffset }
        static var buttonHeight: CGFloat { ArcaneConfiguration.layoutMetrics.buttonHeight }
        static var standardPadding: CGFloat { ArcaneConfiguration.layoutMetrics.standardPadding }
        static var glassCornerRadius: CGFloat { ArcaneConfiguration.layoutMetrics.glassCornerRadius }
        static var neonGlowRadius: CGFloat { ArcaneConfiguration.layoutMetrics.neonGlowRadius }
        static var neonGlowOpacity: Float { ArcaneConfiguration.layoutMetrics.neonGlowOpacity }
        static var buttonWidth: CGFloat { ArcaneConfiguration.layoutMetrics.buttonWidth }
        static var largeButtonHeight: CGFloat { ArcaneConfiguration.layoutMetrics.largeButtonHeight }
        static var regularButtonHeight: CGFloat { ArcaneConfiguration.layoutMetrics.regularButtonHeight }
    }
    
    // Backward compatibility - AnimationDurations
    struct AnimationDurations {
        static var matchDelay: TimeInterval { ArcaneConfiguration.animationDurations.matchDelay }
        static var colorFlash: TimeInterval { ArcaneConfiguration.animationDurations.colorFlash }
        static var dialogAppear: TimeInterval { ArcaneConfiguration.animationDurations.dialogAppear }
        static var dialogDismiss: TimeInterval { ArcaneConfiguration.animationDurations.dialogDismiss }
    }
    
    // Backward compatibility - GameParameters
    struct GameParameters {
        static var timeBonus: Int { ArcaneConfiguration.gameParameters.timeBonus }
        static var leaderboardLimit: Int { ArcaneConfiguration.gameParameters.leaderboardLimit }
    }
}

// MARK: - Resource Provider Protocol

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
