//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Наталья Черномырдина on 28.02.2025.
//  UI-тесты: замена одного постера на другой (при нажатии кнопок Нет/Да), появление алерта по окончанию раунда, скрытие алерта после нажатия кнопки на нем

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError() // начальное состояние приложения
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false // если тест не прошел, дальше не идем
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError() // сбрасываем состояние приложения
        app.terminate()
        app = nil
    }
    
    func testScreenCast() throws {
        app.buttons["Нет"].tap()
    }
    
    func testYesButton() throws {
       // sleep(3) // в зависимости от соединения с сервером можно увеличить время ожидания
        let expectation = self.expectation(description: "Loading expectation") // expectation альтернатива sleep
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation // скриншот в виде данных (тип Data)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
        
        app.buttons["Yes"].tap()
        //sleep(3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { //ожидание пока второй постер не появится
            expectation.fulfill() // условие выполнено
        }
        waitForExpectations(timeout: 3, handler: nil) // ожидание выполнения ожидания
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData) // контенты картинок не должны быть равны
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    
    func testNoButton() throws {
        //sleep(3)
        let expectation = self.expectation(description: "Loading expectation")
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
        
        app.buttons["No"].tap()
        //sleep(3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse (firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testGameFinish() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["universalAlert"] // получаем алерт по идентификатору из AlertPresenter
        
        XCTAssertTrue(alert.exists) // проверка существования алерта - существует
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testAlertDissmis() {
        sleep(2)
        for _ in 1...10 { // получаем окончание раунда
            app.buttons["No"].tap()
            sleep(2)
        }
        let alert = app.alerts["universalAlert"]
        alert.buttons.firstMatch.tap() // получаем текст на кнопке первой и единственной
        
        sleep(2)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists) // проверка существования алерта -  не существует
        XCTAssertEqual(indexLabel.label,"1/10")
    }
}




