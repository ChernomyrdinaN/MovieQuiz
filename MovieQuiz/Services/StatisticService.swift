//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 10.02.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    // MARK: - Properties
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case bestGamecorrect
        case bestGametotal
        case bestGamedate
        case gamesCount
        case totalQuestionAmount
        case correctAnswers
    }
}

extension StatisticService {
    
    var gamesCount: Int { // количество сыграных квизов
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var totalQuestionAmount: Int { // общее количество заданных вопросов за все время
        get { return storage.integer(forKey: Keys.totalQuestionAmount.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalQuestionAmount.rawValue) }
    }
    
    var bestGame: GameResult { // рекорд, лучший результат игры
        get {
            let correct = storage.integer(forKey: Keys.bestGamecorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGametotal.rawValue)
            let date = storage.object(forKey: Keys.bestGamedate.rawValue) as? Date ?? Date()
            return GameResult (correct: correct,total: total,date: date)
        }
        set {
            let currentGame = bestGame
            if newValue.isBetterThan(currentGame) {
                storage.set(newValue.correct, forKey: Keys.bestGamecorrect.rawValue)
                storage.set(newValue.total, forKey: Keys.bestGametotal.rawValue)
                storage.set(newValue.date, forKey: Keys.bestGamedate.rawValue)
            }
        }
    }
    
    var totalAccuracy: Double { // средняя точность прав/ответов за все время
        
        guard gamesCount > 0 else { // проверим знаменатель на ноль
            return 0.0
        }
        let result: Double = Double(correctAnswers) / (Double(gamesCount) * 10) * 100 // формула рассчета средней точности
        return result
    }
    
    private var correctAnswers: Int { // общее количество правильных ответов за все время
        get { return storage.integer(forKey: Keys.correctAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.correctAnswers.rawValue) }
    }
    
    
    // MARK: - Methods
    func store(correct count: Int, total amount: Int) { // метод сохранения текущего результата игры. Метод принимает количество правильных ответов и общее число заданных вопросов
        
        gamesCount += 1 // обновляем количество сыграных игр
        totalQuestionAmount += amount // обновляем количество заданых вопросов
        correctAnswers += count // обновляем количество правильных ответов
        
        let current = bestGame // текущая игра для сравнения и выявления рекорда
        let newValue: GameResult = GameResult(correct: count, total: amount, date: Date())
        
        if newValue.isBetterThan(current) {
            storage.set(newValue.correct, forKey: Keys.bestGamecorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGametotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGamedate.rawValue)
        }
    }
}


