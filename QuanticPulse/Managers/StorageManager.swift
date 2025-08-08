import Foundation

final class StorageManager {
    static let shared = StorageManager()

    private let leaderboardKey = "qp.leaderboard.entries"
    private let unlockedLevelsKey = "qp.levels.unlocked"

    func loadLevels() -> [Level] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("questions.json not found")
            return []
        }
        do {
            let levels = try JSONDecoder().decode([Level].self, from: data)
            return levels
        } catch {
            print("JSON decode error: \(error)")
            return []
        }
    }

    func saveLeaderboard(entries: [LeaderboardEntry]) {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: leaderboardKey)
        } catch {
            print("Failed to save leaderboard: \(error)")
        }
    }

    func loadLeaderboard() -> [LeaderboardEntry] {
        guard let data = UserDefaults.standard.data(forKey: leaderboardKey) else { return [] }
        do {
            let entries = try JSONDecoder().decode([LeaderboardEntry].self, from: data)
            return entries
        } catch {
            print("Failed to load leaderboard: \(error)")
            return []
        }
    }

    func isLevelUnlocked(_ levelId: Int) -> Bool {
        if levelId == 1 { return true }
        let set = Set(UserDefaults.standard.array(forKey: unlockedLevelsKey) as? [Int] ?? [])
        return set.contains(levelId)
    }

    func unlockLevel(_ levelId: Int) {
        var arr = UserDefaults.standard.array(forKey: unlockedLevelsKey) as? [Int] ?? []
        if arr.contains(levelId) == false { arr.append(levelId) }
        UserDefaults.standard.set(arr, forKey: unlockedLevelsKey)
    }
}