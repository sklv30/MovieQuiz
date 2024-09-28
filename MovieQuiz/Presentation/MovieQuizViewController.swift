import UIKit

final class MovieQuizViewController:

    UIViewController {

    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    
    private var testRating = 6.0
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var curreuntQuiz: QuizQuestion?

    private let movies: [MovieData] = [
        MovieData(name: "The Godfather", image: "The Godfather", rating: 9.2),
        MovieData(name: "The Dark Knight", image: "The Dark Knight", rating: 9.0),
        MovieData(name: "Kill Bill", image: "Kill Bill", rating: 8.1),
        MovieData(name: "The Avengers", image: "The Avengers", rating: 8.0),
        MovieData(name: "Deadpool", image: "Deadpool", rating: 8.0),
        MovieData(name: "The Green Knight", image: "The Green Knight", rating: 6.6),
        MovieData(name: "Old", image: "Old", rating: 5.8),
        MovieData(name: "The Ice Age Adventures of Buck Wild", image: "The Ice Age Adventures of Buck Wild", rating: 4.3),
        MovieData(name: "Tesla", image: "Tesla", rating: 5.1),
        MovieData(name: "Vivarium", image: "Vivarium", rating: 5.8)
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curreuntQuiz = quizQuestionBilder(movie: movies[currentQuestionIndex])
        if let curreuntQuiz {
            show(quiz: convert(model: curreuntQuiz))
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let qustionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.question, questionNumber: "\(currentQuestionIndex + 1)/\(movies.count)")
        
        return qustionStep
    }
    
    private func show (quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    private func quizQuestionBilder (movie: MovieData) -> QuizQuestion {
        let quiz = QuizQuestion(image: movie.image, rating: movie.rating, testRating: testRating)
        return quiz
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.YPGreen.cgColor : UIColor.YPRed.cgColor
        imageView.layer.cornerRadius = 15
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == movies.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, btnText: "Сыграть ещё раз")
            imageView.layer.borderWidth = 0
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            curreuntQuiz = quizQuestionBilder(movie: movies[currentQuestionIndex])
            if let curreuntQuiz {
                // Не получается просто рамку через imageView.layer.masksToBounds = false
                imageView.layer.borderWidth = 0
                show(quiz: convert(model: curreuntQuiz))
            }
            
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.btnText, style: .default) {_ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.curreuntQuiz = self.quizQuestionBilder(movie: self.movies[self.currentQuestionIndex])
            if let quiz = self.curreuntQuiz {
                self.show(quiz: self.convert(model: quiz))
            }
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func noBtnClickHandler(_ sender: Any) {
        if let curreuntQuiz {
            showAnswerResult(isCorrect: !curreuntQuiz.correctAnswer)
        }
        
    }
    
    @IBAction func yesBtnClickHandler(_ sender: Any) {
        if let curreuntQuiz {
            showAnswerResult(isCorrect: curreuntQuiz.correctAnswer)
        }
    }
    
}

struct QuizQuestion {
    let image: String
    var rating: Double
    var testRating: Double
    var correctAnswer: Bool {
        rating > testRating ? true : false
    }
    var question: String {
        "Рейтинг этого фильма больше чем \(Int(testRating))?"
    }
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let btnText: String
}

struct MovieData {
    let name: String
    let image: String
    var rating: Double
}
