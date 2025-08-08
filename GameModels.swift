import Foundation

// MARK: - Game Data Models
struct GameData: Codable {
    let levels: [Level]
    let gameSettings: GameSettings
}

struct Level: Codable {
    let id: Int
    let name: String
    let description: String
    let difficulty: String
    let pulseSpeed: Double
    let totalQuestions: Int
    let timePerQuestion: Int
    let pointsPerCorrect: Int
    let questions: [Question]
}

struct Question: Codable {
    let id: Int
    let instruction: String
    let targetIcon: Int
    let targetPulse: Int
    let pulsePattern: [PulsePattern]
    let fakeIcons: [FakeIcon]
}

struct PulsePattern: Codable {
    let pulse: Int
    let lightedIcons: [Int]
}

struct FakeIcon: Codable {
    let icon: Int
    let pulse: Int
}

struct GameSettings: Codable {
    let totalIcons: Int
    let iconTypes: [String]
    let colors: GameColors
    let animations: GameAnimations
}

struct GameColors: Codable {
    let normal: String
    let highlighted: String
    let selected: String
    let fake: String
}

struct GameAnimations: Codable {
    let pulseInDuration: Double
    let pulseOutDuration: Double
    let correctFeedback: String
    let wrongFeedback: String
}

// MARK: - Score Data Model
struct ScoreEntry: Codable {
    let score: Int
    let level: Int
    let levelName: String
    let date: Date
    let playerName: String
    
    init(score: Int, level: Int, levelName: String, playerName: String) {
        self.score = score
        self.level = level
        self.levelName = levelName
        self.date = Date()
        self.playerName = playerName
    }
}

// MARK: - Game Manager
class GameManager {
    static let shared = GameManager()
    
    private var gameData: GameData?
    private var currentLevel: Level?
    private var currentQuestions: [Question] = []
    private var currentQuestionIndex = 0
    private var currentScore = 0
    private var currentTime = 0
    
    private init() {
        loadGameData()
    }
    
    // MARK: - Data Loading
    private func loadGameData() {
        guard let url = Bundle.main.url(forResource: "GameData", withExtension: "json") else {
            print("GameData.json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            gameData = try JSONDecoder().decode(GameData.self, from: data)
            print("Game data loaded successfully")
        } catch {
            print("Error loading game data: \(error)")
        }
    }
    
    // MARK: - Level Management
    func getAllLevels() -> [Level] {
        return gameData?.levels ?? []
    }
    
    func getLevel(by id: Int) -> Level? {
        return gameData?.levels.first { $0.id == id }
    }
    
    func isLevelUnlocked(_ levelId: Int) -> Bool {
        if levelId == 1 { return true } // First level is always unlocked
        
        let completedLevels = UserDefaults.standard.array(forKey: "completedLevels") as? [Int] ?? []
        return completedLevels.contains(levelId - 1) // Previous level must be completed
    }
    
    func unlockLevel(_ levelId: Int) {
        var completedLevels = UserDefaults.standard.array(forKey: "completedLevels") as? [Int] ?? []
        if !completedLevels.contains(levelId) {
            completedLevels.append(levelId)
            UserDefaults.standard.set(completedLevels, forKey: "completedLevels")
        }
    }
    
    // MARK: - Game Session Management
    func startLevel(_ levelId: Int) -> Bool {
        guard let level = getLevel(by: levelId) else { return false }
        
        currentLevel = level
        currentQuestions = level.questions.shuffled() // Shuffle questions
        currentQuestionIndex = 0
        currentScore = 0
        currentTime = level.timePerQuestion
        
        return true
    }
    
    func getCurrentLevel() -> Level? {
        return currentLevel
    }
    
    func getCurrentQuestion() -> Question? {
        guard currentQuestionIndex < currentQuestions.count else { return nil }
        
        var question = currentQuestions[currentQuestionIndex]
        // Shuffle answer positions (not implemented in this basic version)
        return question
    }
    
    func getCurrentQuestionIndex() -> Int {
        return currentQuestionIndex
    }
    
    func getTotalQuestions() -> Int {
        return currentQuestions.count
    }
    
    func getCurrentScore() -> Int {
        return currentScore
    }
    
    func getCurrentTime() -> Int {
        return currentTime
    }
    
    // MARK: - Game Logic
    func checkAnswer(iconTapped: Int, pulseTapped: Int) -> Bool {
        guard let question = getCurrentQuestion() else { return false }
        
        let isCorrect = (iconTapped == question.targetIcon && pulseTapped == question.targetPulse)
        
        if isCorrect {
            currentScore += currentLevel?.pointsPerCorrect ?? 10
            // Bonus for quick answer
            if currentTime > (currentLevel?.timePerQuestion ?? 15) / 2 {
                currentScore += 5
            }
        } else {
            currentScore = max(0, currentScore - 5) // Penalty for wrong answer
        }
        
        return isCorrect
    }
    
    func nextQuestion() -> Bool {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < currentQuestions.count {
            currentTime = currentLevel?.timePerQuestion ?? 15
            return true
        } else {
            // Level completed
            if let level = currentLevel {
                unlockLevel(level.id)
                saveScore()
            }
            return false
        }
    }
    
    func updateTime() {
        currentTime = max(0, currentTime - 1)
    }
    
    func isTimeUp() -> Bool {
        return currentTime <= 0
    }
    
    func skipQuestion() {
        currentScore = max(0, currentScore - 10) // Penalty for skipping
        currentTime = max(0, currentTime - 5) // Time penalty
        _ = nextQuestion()
    }
    
    func pauseGame() {
        // Pause logic can be implemented here
    }
    
    func resumeGame() {
        // Resume logic can be implemented here
    }
    
    // MARK: - Score Management
    private func saveScore() {
        guard let level = currentLevel else { return }
        
        let playerName = UserDefaults.standard.string(forKey: "playerName") ?? "Anonymous"
        let scoreEntry = ScoreEntry(score: currentScore, level: level.id, levelName: level.name, playerName: playerName)
        
        var scores = getHighScores()
        scores.append(scoreEntry)
        scores.sort { $0.score > $1.score }
        
        // Keep only top 50 scores
        if scores.count > 50 {
            scores = Array(scores.prefix(50))
        }
        
        if let encodedScores = try? JSONEncoder().encode(scores) {
            UserDefaults.standard.set(encodedScores, forKey: "highScores")
        }
        
        // Update total stats
        let totalScore = UserDefaults.standard.integer(forKey: "totalScore")
        let gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")
        
        UserDefaults.standard.set(totalScore + currentScore, forKey: "totalScore")
        UserDefaults.standard.set(gamesPlayed + 1, forKey: "gamesPlayed")
    }
    
    func getHighScores() -> [ScoreEntry] {
        guard let data = UserDefaults.standard.data(forKey: "highScores"),
              let scores = try? JSONDecoder().decode([ScoreEntry].self, from: data) else {
            return []
        }
        return scores.sorted { $0.score > $1.score }
    }
    
    func getPlayerRank(for playerName: String) -> String {
        let scores = getHighScores()
        let playerScores = scores.filter { $0.playerName == playerName }
        
        if let bestScore = playerScores.first?.score {
            if bestScore >= 500 {
                return "Pulse God 🔥"
            } else if bestScore >= 300 {
                return "Rhythm Master 🎵"
            } else if bestScore >= 200 {
                return "Beat Expert 🎯"
            } else if bestScore >= 100 {
                return "Pulse Pro ⚡"
            } else if bestScore >= 50 {
                return "Tempo Trainee 🎼"
            } else {
                return "Pulse Beginner 🌟"
            }
        }
        
        return "New Player 👋"
    }
    
    // MARK: - Game Settings
    func getGameSettings() -> GameSettings? {
        return gameData?.gameSettings
    }
    
    func getTotalIcons() -> Int {
        return gameData?.gameSettings.totalIcons ?? 5
    }
    
    func getIconTypes() -> [String] {
        return gameData?.gameSettings.iconTypes ?? ["circle", "star", "heart", "diamond", "triangle"]
    }
}