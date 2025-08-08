import Foundation

final class GameEngine {
    let level: Level
    private(set) var questions: [PulseQuestion]
    private(set) var currentIndex: Int = 0
    private(set) var score: Int = 0
    private(set) var streak: Int = 0

    var isCompleted: Bool { currentIndex >= questions.count }

    init(level: Level) {
        self.level = level
        // Shuffle questions each game
        self.questions = level.questions.shuffled()
    }

    func currentQuestion() -> PulseQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    func advanceOnCorrect() {
        score += 10 + (streak * 2)
        streak += 1
        currentIndex += 1
    }

    func resetStreak() {
        streak = 0
    }

    func applySkipPenalty() {
        score = max(0, score - 5)
    }

    func applyWrongPenalty() {
        score = max(0, score - 8)
        resetStreak()
    }
}