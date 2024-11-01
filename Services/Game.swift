import Foundation
import UIKit

class Game: QuestionFactoryDelegate {
    var questionQuantuty: Int
    var currentQuestionNumber: Int = 0
    private var currentQuestionRating: Double = 0.0
    var correctAnswers: Int = 0
    let questionFactory: QuestionFactory
    weak var gameDelegate: GameDelegate?
    let statisticService: StatisticServiceProtocol
    
    init(questionQuantuty: Int) {
        self.questionQuantuty = questionQuantuty
        self.questionFactory = QuestionFactory()
        self.statisticService = StatisticService()
        self.questionFactory.delegate = self
    }
    
    private func prepareQuestionView(_ movie: MovieData) -> QuestionViewModel {
        let question = QuestionViewModel(
            image: UIImage(named: movie.image) ?? UIImage(),
            question: "Рейтинг этого фильма больше чем 6?",
            questionNumber: "\(currentQuestionNumber + 1)/\(questionQuantuty)"
        )
        return question
    }
    
    func didReceiveNextQuestion(_ movie: MovieData?) {
        
        guard let movie = movie else {
                return
        }
        
        let newQestion = prepareQuestionView(movie)
        currentQuestionRating = movie.rating
        currentQuestionNumber += 1
        
        DispatchQueue.main.async { [weak self] in
            self?.gameDelegate?.showQuestion(newQestion)
        }
        
    }
    
    func startNewRound() {
        questionFactory.requestNextQuestion()
    }
    
    func checkAnswer() -> Bool {
        return currentQuestionRating > 6.0 ? true : false
    }
    
    func checkGameLength() -> Bool {
        return questionQuantuty >= currentQuestionNumber + 1 ? true : false
    }
    
    func restartGame() {
        currentQuestionNumber = 0
        correctAnswers = 0
    }
    
    func updateStatistic(_ currentGameResult: Int,_ currentGameRoundsCount: Int) {
        self.statisticService.store(roundsCount: currentGameResult, winsRoundCount: currentGameRoundsCount)
    }
    
    func showStatistic(currentGameResult: Int, currentGameRoundsCount: Int) -> String {
        return self.statisticService.showStatistic(currentGameResult: currentGameResult, currentGameRoundsCount: currentGameRoundsCount)
    }
}
