//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 29.01.2025.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol { // класс-сервис генерации новых вопросов
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // метод загрузки данных с сервера
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке MovieQuizViewController
                }
            }
        }
    }
    
    // метод запроса следующего вопроса
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in // отправляем в фоновую очередь
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer) // инициализируем модель
            DispatchQueue.main.async { [weak self] in // возвращаем в основную очередь для обновления
                self?.delegate?.didReceiveNextQuestion(question: question) // получен ли вопрос
            }
        }
    }
}
