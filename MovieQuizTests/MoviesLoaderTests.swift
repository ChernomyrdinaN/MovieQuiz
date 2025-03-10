//
//  MoviesLoaderTests.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 28.02.2025.
//  unit-тесты для проверки успешной и неуспешной загрузки данных

import Foundation
import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {
    
    struct StubNetworkClient: NetworkRouting { // тестовый объект для имитации сетевого клиента
        
        enum TestError: Error { // тестовая ошибка
            case test
        }
        let emulateError: Bool // эмулируем либо ошибку сети, либо успешный ответ
        
        func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
            if emulateError {
                handler(.failure(TestError.test))
            } else {
                handler(.success(expectedResponse))
            }
        }
        private var expectedResponse: Data {
            """
            {
               "errorMessage" : "",
               "items" : [
                  {
                     "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
                     "fullTitle" : "Prey (2022)",
                     "id" : "tt11866324",
                     "imDbRating" : "7.2",
                     "imDbRatingCount" : "93332",
                     "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
                     "rank" : "1",
                     "rankUpDown" : "+23",
                     "title" : "Prey",
                     "year" : "2022"
                  },
                  {
                     "crew" : "Anthony Russo (dir.), Ryan Gosling, Chris Evans",
                     "fullTitle" : "The Gray Man (2022)",
                     "id" : "tt1649418",
                     "imDbRating" : "6.5",
                     "imDbRatingCount" : "132890",
                     "image" : "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg",
                     "rank" : "2",
                     "rankUpDown" : "-1",
                     "title" : "The Gray Man",
                     "year" : "2022"
                  }
                ]
              }
            """.data(using: .utf8) ?? Data()
        } // созданный тестовый ответ от сервера в формате Data
    }
    
    func testSuccessLoading() throws { // тест на успешную загрузку данных с сервера
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false) // не эмулируем ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2) // проверяем сколько пришло фильмов
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true) // эмулируем ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            
            // Then
            switch result {
            case .failure (let error): // проверяем что пришла ошибка
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(_): // функция loader.loadMovies работает успешно
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
}

