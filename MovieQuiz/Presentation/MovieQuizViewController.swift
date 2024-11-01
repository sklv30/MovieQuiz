import UIKit

final class MovieQuizViewController: UIViewController, GameDelegate {
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noBtn: UIButton!
    @IBOutlet private weak var yesBtn: UIButton!
    let game = Game(questionQuantuty: 10)
    let alert = ResultAlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.gameDelegate = self
        game.startNewRound()
    }
    
    func showQuestion(_ question: QuestionViewModel) {
        questionLabel.text = question.question
        imageView.image = question.image
        counterLabel.text = question.questionNumber
    }
    
    private func showResultAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerOrResult(isCorrect: Bool) {
        addBorder(isCorrect: isCorrect)
        if isCorrect {
            game.correctAnswers += 1
        }
        changeStateButton(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            if self.game.checkGameLength() {
                self.showAnswer()
            } else {
                self.showResult()
            }
        }
    }
    
    private func showAnswer() {
        game.startNewRound()
        imageView.layer.borderWidth = 0
        changeStateButton(isEnabled: true)
    }
    
    private func showResult() {
        game.updateStatistic(game.questionQuantuty, game.correctAnswers)
        showResultAlert(alert: alert.buildAlert(game: game))
        imageView.layer.borderWidth = 0
        changeStateButton(isEnabled: true)
    }
    
    private func addBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    private func changeStateButton(isEnabled: Bool) {
        noBtn.isEnabled = isEnabled
        yesBtn.isEnabled = isEnabled
    }
    
    @IBAction private func noBtnClickHandler(_ sender: Any) {
        showAnswerOrResult(isCorrect: !game.checkAnswer())
    }
    @IBAction private func yesBtnClickHandler(_ sender: Any) {
        showAnswerOrResult(isCorrect: game.checkAnswer())
    }
    
}
