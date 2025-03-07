//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Наталья Черномырдина on 07.03.2025.
//  unit-тесты для presenter'а

import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    
    var alertDialog: MovieQuiz.AlertPresenter?
    
    func showLoadingIndicator() {}

    func hideLoadingIndicator() {}

    func show(quiz step: MovieQuiz.QuizStepViewModel) {}

    func highlightImageBorder(isCorrectAnswer: Bool) {}

    func hideBorder() {}

    func changeStateButton(isEnabled: Bool) {}

    func showNetworkError(message: String) {}

    
}

final class MovieQuizPresenterTests: XCTestCase {
    private var viewControllerMock: Data { """
              {
              "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
              "text" : "Question Text",
              "correctAnswer" : true
              }
              """.data(using: .utf8) ?? Data()
    }
          
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}



