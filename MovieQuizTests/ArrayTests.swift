//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 28.02.2025.
//  unit-тесты на сабскрипт для безопасного получения элемента из массива по индексу

import Foundation
import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    
    func testGetValueInRange() throws { // тест на взятие элемента по правильному индексу
        //Given
        let array = [1,1,2,3,5]
        
        //When
        let value = array [safe: 2] // в случае ошибки возвращаем nil
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    func testGetValueOutOfRange() throws { // тест на взятие элемента по НЕправильному индексу
        //Given
        let array = [1,1,2,3,5]
        
        //When
        let value = array [safe: 20]
        
        //Then
        XCTAssertNil(value)
    }
}
    
