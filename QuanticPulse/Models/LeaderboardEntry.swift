import Foundation

struct LeaderboardEntry: Codable, Equatable {
    let playerName: String
    let score: Int
    let levelId: Int
    let date: Date
}