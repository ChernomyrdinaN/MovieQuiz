//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 02.02.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject { // создаем протокол для делегата фабрики
    
    func didReceiveNextQuestion(question: QuizQuestion?) // метод делегата фабрики для вызова подготовленного вопроса
}
