import UIKit
import Foundation

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var correctAnswers = 0 // переменная со счетчиком правильных ответов (начальная)
    private let presenter = MovieQuizPresenter() // создаем экземпляр класса MovieQuizPresenter
    var questionFactory: QuestionFactoryProtocol? // переменная-протокол от фабрики вопросов, с учетом DI
    //private var currentQuestion: QuizQuestion? // переменная-вопрос показанный пользователю
    var alertDialog: AlertPresenter? // создаем экземпляр клааса AlertPresenter
    var statisticService: StatisticServiceProtocol? // создаем экземпляр класса StatisticService
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.requestNextQuestion() // используем ? при обращении к свойствам и методам опционального типа данных
        alertDialog = AlertPresenter(alertController: self) // инициализация
        statisticService = StatisticService() // инициализация
        showLoadingIndicator() // показ индикатора
        questionFactory?.loadData() // запуск загрузки данных с сервера
    }
    
    // MARK: - Methods
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    func didFailToLoadData(with error: Error) { // реакция на ошибку загрузки
        showNetworkError(message: error.localizedDescription) // метод показа сетевой ошибки
    }
    func didLoadDataFromServer() { // реакция на успешную загрузку
        activityIndicator.stopAnimating() // метод скрытия индикатора загрузки
        questionFactory?.requestNextQuestion()
    }
    func showAnswerResult (isCorrect: Bool) { // приватный метод отображения результата ответов
        if isCorrect {
            correctAnswers += 1
        }
        //imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            dispatch()
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            dispatch()
        }
    }
    func show(quiz step: QuizStepViewModel) { // приватный метод вывода на экран вопроса, который принимает на вход вью модель
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    private func dispatch() { // приватный метод-диспетчеризации позволяет откладывать выполнение функции на 1 сек
        DispatchQueue.main.asyncAfter (deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            presenter.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    private func show(quiz result: QuizResultsViewModel) { // приватный метод показа результатов раунда квиза
        statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
        
        let alert = UIAlertController( // создание самого алерта
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard self != nil else { return }
        }
        alert.addAction(action) // добавление кнопки в алерт
        self.present(alert, animated: true, completion: nil)
        self.presenter.resetQuestionIndex()
    }
    private func changeStateButton(isEnabled: Bool) { // блокировка и разблокировка кнопок
        yesButton.isEnabled  = isEnabled
        noButton.isEnabled = isEnabled
    }
    private func showLoadingIndicator() {
        activityIndicator.startAnimating() // запуск анимации
    }
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating() // стоп анимации
    }
    private func showNetworkError(message: String) { // метод показа алерта
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self else { return }
                
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.loadData() // попытка загрузки данных
            }
        alertDialog?.alertShow(model: alert) //
        
    }
    
    // MARK: - IBActions
    // обработка нажатия кнопок Да/Het пользователем
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        changeStateButton(isEnabled: false)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        changeStateButton(isEnabled: false)
    }
}

