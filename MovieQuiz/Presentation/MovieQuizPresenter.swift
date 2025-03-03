//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 03.03.2025.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1 // последний вопрос
    }
    func resetQuestionIndex() {
        currentQuestionIndex = 0 // сброс индекса вопроса
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1 // переход к следующему вопросу
    }
    func convert(model: QuizQuestion) -> QuizStepViewModel { // метод преобразованиея из Модели (QuizQuestion) в Представление QuizStepViewModel)
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)" // ОШИБКА: `currentQuestionIndex` и `questionsAmount` неопределены
        )
    }
}
