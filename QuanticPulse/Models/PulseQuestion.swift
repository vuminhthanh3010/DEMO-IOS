import Foundation

struct PulseQuestion: Codable, Equatable {
    let id: Int
    let numIcons: Int
    let targetIconIndex: Int
    let targetPulseNumber: Int
    let fakePulses: [Int: [Int]]
    let hints: [String]
    let options: [String]
    let correctOptionIndex: Int
}