import Foundation
import UIKit

class ResultAlertPresenter {
    
    func buildAlert(game: Game) -> UIAlertController {
        let result = prepareResultViewModel(game: game)
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.btnText, style: .default) { _ in
            game.restartGame()
            game.startNewRound()
        }
        alert.addAction(action)
        
        return alert
    }
    
    private func prepareResultViewModel(game: Game) -> QuizResultsViewModel {
        let result = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: game.showStatistic(currentGameResult: game.correctAnswers, currentGameRoundsCount: game.questionQuantuty),
            btnText: "Сыграть ещё раз"
        )
        
        return result
    }
}
