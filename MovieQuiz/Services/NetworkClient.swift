//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 23.02.2025.
//

import Foundation

struct NetworkClient { // отвечает за загрузку данных по URL

    private enum NetworkError: Error { // реализация протокола Error для обработки ошибок
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { // проверяем,пришла ли ошибка
                handler(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse, // проверяем,что нам пришёл успешный код ответа
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            guard let data else {return handler(.failure(NetworkError.codeError))   } // возвращаем данные
            handler(.success(data))
        }
        task.resume() // продолжение выполнения task
    }
}
