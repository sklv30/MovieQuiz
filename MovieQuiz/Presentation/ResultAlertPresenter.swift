import Foundation
import UIKit

final class ResultAlertPresenter {
    
    func buildAlert(game: Game, statistics: StatisticService) -> UIAlertController {
        let result = prepareResultViewModel(game: game, statistics: statistics)
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.btnText, style: .default) { _ in
            game.restartGame()
            game.startNewRound()
        }
        alert.addAction(action)
        
        return alert
    }
    
    private func prepareResultViewModel(game: Game, statistics: StatisticService) -> QuizResultsViewModel {
        let result = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: statistics.showStatistic(currentGameResult: game.correctAnswers, currentGameRoundsCount: game.questionQuantuty),
            btnText: "Сыграть ещё раз"
        )
        
        return result
    }
}
