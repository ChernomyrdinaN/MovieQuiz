//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 10.02.2025.
//

import Foundation

struct GameResult { // структура игры
    let correct: Int // количество прав/ответов
    let total: Int // количество вопросов квиза
    let date: Date // дата завершения раунда
    func isBetterThan(_ another: GameResult) -> Bool {// метод сраненения прав/ответов
        correct > another.correct
    }
}
