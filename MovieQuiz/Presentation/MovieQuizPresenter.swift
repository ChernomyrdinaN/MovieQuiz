//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 03.03.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionsAmount: Int = 10
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var currentQuestionIndex: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol!
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel { // метод преобразованиея из Модели (QuizQuestion) в Представление QuizStepViewModel)
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)" // ОШИБКА: `currentQuestionIndex` и `questionsAmount` неопределены
        )
    } // метод конвертации модели
   
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    } // загрузка данных с сервера
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    } // данные не загружены
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { // если вопрос не придет работа метода прекратиться
            return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in //обновляем UI только с главной очереди
            self?.viewController?.show(quiz: viewModel)
        }
    } // получение следующего вопроса
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    } // нажатие кнопки "Да"
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    } // нажатие кнопки "Нет"
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion else {
            return
        }
        let givenAnswer = isYes // ответ пользователя Да/Нет
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    } // получен ответ
    
    func showNextQuestionOrResults() { // приватный метод перехода в один из сценариев
        if self.isLastQuestion() { // переход в "Результат квиза"
            let alert = AlertModel(
                title: "Этот раунд окончен!",
                message: "Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)\n Количество сыграных квизов: \(viewController?.statisticService?.gamesCount ?? 1) \n Рекорд: \(viewController?.statisticService?.bestGame.correct ?? self.correctAnswers)/\(viewController?.statisticService?.bestGame.total ?? self.questionsAmount) (\(viewController?.statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString)) \n Средняя точность: \(String(format: "%.2f", viewController?.statisticService?.totalAccuracy ?? 0))%",
                buttonText: "Сыграть еще раз!") { [weak self] in
                    guard let self else { return }
                    self.restartGame()
                }
            self.viewController?.alertDialog?.alertShow(model: alert)
        }
        else { // переход в "Вопрос показан"
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion() // используем ? при обращении к свойствам и методам опционального типа данных
        }
    } // показ следующего вопроса или результат игры
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    } // переход к следующему вопросу
    
    func showAnswerResult(isCorrect: Bool) { // показ результата ответа
        //imageView.layer.masksToBounds = true
        if isCorrect {
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
            correctAnswers += 1
        } else {
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        }
        dispatch()
    } // показ результата ответа
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    } // показ последнего вопроса
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    } // перезапуск игры
    
    private func dispatch() { // приватный метод-диспетчеризации позволяет откладывать выполнение функции на 1 сек
        DispatchQueue.main.asyncAfter (deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            showNextQuestionOrResults()
            viewController?.hideBorder()
            viewController?.changeStateButton(isEnabled: true)
        }
    } // отправка
}






