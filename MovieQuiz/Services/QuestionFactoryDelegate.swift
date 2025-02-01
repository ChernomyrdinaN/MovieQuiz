//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 02.02.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject { // создание протокола-делегата для фабрики
    func didReceiveNextQuestion(question: QuizQuestion?) // метод делегата фабрики для вызова готового вопроса
}
