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
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
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
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { // если вопрос не придет работа метода прекратиться
            return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in //обновляем UI только с главной очереди
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func showNextQuestionOrResults () { // приватный метод перехода в один из сценариев
        if self.isLastQuestion() { // переход в "Результат квиза"
            let alert = AlertModel(
                title: "Этот раунд окончен!",
                message: "Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)\n Количество сыграных квизов: \(viewController?.statisticService?.gamesCount ?? 1) \n Рекорд: \(viewController?.statisticService?.bestGame.correct ?? self.correctAnswers)/\(viewController?.statisticService?.bestGame.total ?? self.questionsAmount) (\(viewController?.statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString)) \n Средняя точность: \(String(format: "%.2f", viewController?.statisticService?.totalAccuracy ?? 0))%",
                buttonText: "Сыграть еще раз!") { [weak self] in
                    guard let self else { return }
                    
                    self.correctAnswers = 0
                    self.resetQuestionIndex()
                    viewController?.questionFactory?.requestNextQuestion()
                }
            
            //alertDialog?.alertShow(model: alert)
            self.viewController?.alertDialog?.alertShow(model: alert)
            
            
        } else { // переход в "Вопрос показан"
            self.switchToNextQuestion()
            viewController?.questionFactory?.requestNextQuestion() // используем ? при обращении к свойствам и методам опционального типа данных
        }
    }
    
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes // ответ пользователя Да/Нет
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
   }





