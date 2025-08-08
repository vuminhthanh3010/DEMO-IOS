import Foundation

final class SettingsManager {
    static let shared = SettingsManager()
    private let playerNameKey = "qp.player.name"

    var playerName: String {
        get { UserDefaults.standard.string(forKey: playerNameKey) ?? "Player" }
        set { UserDefaults.standard.set(newValue, forKey: playerNameKey) }
    }
}