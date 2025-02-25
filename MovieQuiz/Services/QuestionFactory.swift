//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 29.01.2025.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol { // класс-сервис генерации новых вопросов
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = [] //будем складывать туда фильмы, загруженные с сервера
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
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
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
}
// мок-данные
/*
 // MARK: - Properties
 private let questions: [QuizQuestion] = [ // переменная-массив со списком вопросов
 QuizQuestion (
 image: "The Godfather",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer:true),
 QuizQuestion (
 image: "The Dark Knight",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true
 ),
 QuizQuestion (
 image: "Kill Bill",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true
 ),
 QuizQuestion (
 image: "The Avengers",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true
 ),
 QuizQuestion (
 image: "Deadpool",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true
 ),
 QuizQuestion (
 image: "The Green Knight",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true
 ),
 QuizQuestion (
 image:"Old",
 text:"Рейтинг этого фильма больше чем 6?",
 correctAnswer: false
 
 ),
 QuizQuestion (
 image: "The Ice Age Adventures of Buck Wild",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false
 ),
 QuizQuestion (
 image: "Tesla",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false
 ),
 QuizQuestion (
 image: "Vivarium",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false
 )
 ]*/










