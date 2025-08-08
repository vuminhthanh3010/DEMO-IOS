import Foundation

struct Level: Codable, Equatable {
    let id: Int
    let name: String
    let difficulty: Int
    let pulseSpeedSeconds: Double
    let totalPulsesPerQuestion: Int
    let questions: [PulseQuestion]
}