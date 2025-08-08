import UIKit

final class ThemeManager {
    static let shared = ThemeManager()

    private let darkModeKey = "qp.darkmode.enabled"

    var isDarkModeEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: darkModeKey) }
        set { UserDefaults.standard.set(newValue, forKey: darkModeKey) }
    }

    var backgroundColor: UIColor {
        isDarkModeEnabled ? UIColor.black : UIColor.systemBackground
    }

    var primaryTextColor: UIColor {
        isDarkModeEnabled ? UIColor.white : UIColor.label
    }

    var secondaryTextColor: UIColor {
        isDarkModeEnabled ? UIColor(white: 0.85, alpha: 1) : UIColor.secondaryLabel
    }

    var currentTintColor: UIColor {
        isDarkModeEnabled ? UIColor.systemTeal : UIColor.systemIndigo
    }

    var defaultGradient: [UIColor] {
        if isDarkModeEnabled {
            return [UIColor.black, UIColor.darkGray]
        } else {
            return [UIColor.systemTeal.withAlphaComponent(0.5), UIColor.systemBlue.withAlphaComponent(0.5)]
        }
    }

    func gradientForScreen(_ screen: String) -> [UIColor] {
        switch screen {
        case "Splash":
            return isDarkModeEnabled ? [UIColor.black, UIColor.systemBlue] : [UIColor.systemIndigo, UIColor.systemTeal]
        case "Home":
            return isDarkModeEnabled ? [UIColor.black, UIColor.systemPurple] : [UIColor.systemPurple, UIColor.systemPink]
        case "Levels":
            return isDarkModeEnabled ? [UIColor.black, UIColor.systemGreen] : [UIColor.systemGreen, UIColor.systemMint]
        case "Game":
            return isDarkModeEnabled ? [UIColor.black, UIColor.systemOrange] : [UIColor.systemOrange, UIColor.systemYellow]
        case "Leaderboard":
            return isDarkModeEnabled ? [UIColor.black, UIColor.systemCyan] : [UIColor.systemCyan, UIColor.systemBlue]
        case "Settings":
            return isDarkModeEnabled ? [UIColor.black, UIColor.systemGray] : [UIColor.systemGray2, UIColor.systemGray6]
        case "Tutorial":
            return isDarkModeEnabled ? [UIColor.black, UIColor.systemRed] : [UIColor.systemRed, UIColor.systemOrange]
        case "GameOver":
            return isDarkModeEnabled ? [UIColor.black, UIColor.systemPink] : [UIColor.systemPink, UIColor.systemPurple]
        default:
            return defaultGradient
        }
    }
}