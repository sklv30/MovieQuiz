import Foundation

protocol StatisticService {
    var roundsCount: Int {get}
    var winsRoundCount: Int {get}
    var gamesCount: Int {get}
    var bestGame: GameResult {get}
    
    func showStatistic(currentGameResult: Int, currentGameRoundsCount: Int) -> String
    
    func store(roundsCount: Int, winsRoundCount: Int)
}
