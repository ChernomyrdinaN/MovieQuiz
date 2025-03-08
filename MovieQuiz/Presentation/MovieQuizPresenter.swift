//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 03.03.2025.
//

import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    
    // показ последнего вопроса
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    // перезапуск игры
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    // переход к следующему вопросу
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // метод конвертации модели
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // нажатие кнопки "Да"
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    // нажатие кнопки "Нет"
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // получен ответ пользователя
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else {
            return
        }
        let givenAnswer = isYes // ответ пользователя Да/Нет
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // показ следующего вопроса или результат игры
    private func showNextQuestionOrResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        if self.isLastQuestion() { // переход в "Результат квиза"
            let alert = AlertModel(
                title: "Этот раунд окончен!",
                message: "Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)\n Количество сыграных квизов: \(statisticService?.gamesCount ?? 1) \n Рекорд: \(statisticService?.bestGame.correct ?? self.correctAnswers)/\(statisticService?.bestGame.total ?? self.questionsAmount) (\(statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%",
                buttonText: "Сыграть еще раз") { [weak self] in
                    guard let self else {
                        return
                    }
                    self.restartGame()
                }
            self.viewController?.alertDialog?.alertShow(model: alert)
        }
        else { // переход в "Вопрос показан"
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    // показ результата ответа
    private func showAnswerResult(isCorrect: Bool) { // показ результата ответа
        //imageView.layer.masksToBounds = true
        if isCorrect {
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
            correctAnswers += 1
        } else {
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        }
        dispatch()
    }
    
    // метод асинхронной отправки
    private func dispatch() {
        DispatchQueue.main.asyncAfter (deadline: .now() + 1.0) { [weak self] in
            guard let self else {
                return
            }
            showNextQuestionOrResults()
            viewController?.hideBorder()
            viewController?.changeStateButton(isEnabled: true)
        }
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    // загрузка данных с сервера
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    // данные не загружены
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    // получение следующего вопроса
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in //обновляем UI с главной очереди
            self?.viewController?.show(quiz: viewModel)
        }
    }
}






