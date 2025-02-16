//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 10.02.2025.
//

import Foundation

protocol StatisticServiceProtocol { // ограничим возможность записи данных в переменные извне геттерами    
    var gamesCount: Int { get } // количество завершенных игр
    var bestGame: GameResult { get } // лучшая игра, рекорд
    var totalAccuracy: Double { get } // средняя точность прав/ответов за все игры в %
    
    func store(correct count: Int, total amount: Int) // метод для сохранения текущего результата игры
}


