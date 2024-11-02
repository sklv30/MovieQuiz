import Foundation
import UIKit

final class Game {
    var questionQuantuty: Int
    var correctAnswers: Int = 0
    weak var gameDelegate: GameDelegate?
    
    private var currentQuestionNumber: Int = 0
    private var currentQuestionRating: Double = 0.0
    private let questionFactory: QuestionFactory
    
    init(questionQuantuty: Int) {
        self.questionQuantuty = questionQuantuty
        self.questionFactory = QuestionFactory()
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
    
    func startNewRound() {
        questionFactory.requestNextQuestion()
    }
    
    func checkAnswer() -> Bool {
        return currentQuestionRating > 6.0 ? true : false
    }
    
    func checkGameLength() -> Bool {
        return questionQuantuty >= currentQuestionNumber + 1
    }
    
    func restartGame() {
        currentQuestionNumber = 0
        correctAnswers = 0
    }
}

extension Game: QuestionFactoryDelegate {
    func didReceiveNextQuestion(_ movie: MovieData?) {
        guard let movie = movie else {
            return
        }
        
        let newQestion = prepareQuestionView(movie)
        currentQuestionRating = movie.rating
        currentQuestionNumber += 1
        
        DispatchQueue.main.async {
            self.gameDelegate?.showQuestion(newQestion)
        }
    }
}
