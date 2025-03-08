//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 07.03.2025.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    var alertDialog: AlertPresenter? {get set}
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func hideBorder()
    func changeStateButton(isEnabled: Bool)
    func showNetworkError(message: String)

}
