import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
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
    
    func requestNextQuestion() {
        guard let index = (0..<movies.count).randomElement() else {
            delegate?.didReceiveNextQuestion(nil)
            return
        }
        let movie = movies[safe: index]
        delegate?.didReceiveNextQuestion(movie)
    }
}
