//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 29.01.2025.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol { // класс-сервис генерации новых вопросов
    
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
    ]
    weak var delegate: QuestionFactoryDelegate? // используем это свойство для инъекции (DI)
    init (delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    func requestNextQuestion () { // приватный метод показа следующего вопроса
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question) // вызываем делегат и передаем в него модель вопроса
    }
}


