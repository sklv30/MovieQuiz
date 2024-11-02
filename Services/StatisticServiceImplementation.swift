import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case roundsCount
        case winsRoundCount
        case gamesCount
        case bestGameData
        case bestGameWins
        case bestGameRounds
    }
    
    var roundsCount: Int {
        get {
            storage.integer(forKey: Keys.roundsCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.roundsCount.rawValue)
        }
    }
    var winsRoundCount: Int {
        get {
            storage.integer(forKey: Keys.winsRoundCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.winsRoundCount.rawValue)
        }
    }
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameResult {
        get {
            let rounds = storage.integer(forKey: Keys.bestGameRounds.rawValue)
            let correctRounds = storage.integer(forKey: Keys.bestGameWins.rawValue)
            let date = storage.object(forKey: Keys.bestGameData.rawValue) as? Date ?? Date()
            
            return GameResult(date: date, rounds: rounds, correctRounds: correctRounds)
        }
        set {
            storage.set(newValue.rounds, forKey: Keys.bestGameRounds.rawValue)
            storage.set(newValue.correctRounds, forKey: Keys.bestGameWins.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameData.rawValue)
        }
    }
    
    private let storage: UserDefaults = .standard
    
    func checkOrUpdateBestGame(roundsCount: Int, correctRoundCount: Int, oldCorrectRoundCount: Int) {
        if oldCorrectRoundCount < correctRoundCount {
            let newBestGame = GameResult(date: Date(), rounds: roundsCount, correctRounds: correctRoundCount)
            self.bestGame = newBestGame
        }
    }
    
    func store(roundsCount: Int, winsRoundCount: Int) {
        self.gamesCount += 1
        self.roundsCount += roundsCount
        self.winsRoundCount += winsRoundCount
        checkOrUpdateBestGame(roundsCount: roundsCount, correctRoundCount: winsRoundCount, oldCorrectRoundCount: self.bestGame.correctRounds)
    }
    
    func countAverageWins(games: Int, wins: Int) -> Double {
        return Double(wins) / Double(games) * 100
    }
    
    func showStatistic(currentGameResult: Int, currentGameRoundsCount: Int) -> String {
        
        let gameResult = "Ваш результат: \(currentGameResult)/\(currentGameRoundsCount)"
        let totalGames = "Количество сыгранных квизов: \(self.gamesCount)"
        let bestResult = "Рекорд: \(self.bestGame.correctRounds)/\(self.bestGame.rounds) (\(self.bestGame.date.dateTimeString))"
        let averrageResult = "Средняя точность: \(String(format: "%.2f", countAverageWins(games: self.roundsCount, wins: self.winsRoundCount)))%"
        
        return "\(gameResult)\n\(totalGames)\n\(bestResult)\n\(averrageResult)"
    }
}
