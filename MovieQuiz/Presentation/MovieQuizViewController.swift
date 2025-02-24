import UIKit
import Foundation

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{ // класс подписываем на протокол делегата фабрики и алерта
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var currentQuestionIndex = 0 // переменная с индексом текущего вопроса (начальная)
    private var correctAnswers = 0 // переменная со счетчиком правильных ответов (начальная)
    private let questionsAmount: Int = 10 // переменная-количество вопросов
    private var questionFactory: QuestionFactoryProtocol? // переменная-протокол от фабрики вопросов, с учетом DI
    private var currentQuestion: QuizQuestion? // переменная-вопрос показанный пользователю
    private var alertDialog: AlertPresenter? // созадаем экземпляр клааса AlertPresenter
    private var statisticService: StatisticServiceProtocol? // создаем экземпляр класса StatisticService
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.requestNextQuestion() // используем ? при обращении к свойствам и методам опционального типа данных
        alertDialog = AlertPresenter(alertController: self) // инициализация
        statisticService = StatisticService() // инициализация
        
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - Methods
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { // если вопрос не придет работа метода прекратиться
            return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in //обновляем UI только с главной очереди
            self?.show(quiz: viewModel)}
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel { //приватный метод конвертации, который возвращает вью
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(), // инициализация
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) { // приватный метод вывода на экран вопроса, который принимает на вход вью модель
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult (isCorrect: Bool) { // приватный метод отображения результата ответов
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
    private func dispatch() { // приватный метод-диспетчеризации позволяет откладывать выолнение функции на 1 сек
        DispatchQueue.main.asyncAfter (deadline: .now() + 1.0) { [weak self] in // используем слабую ссылку во избежании увеличения счетчика ссылок объекта
            guard let self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults () { // приватный метод перехода в один из сценариев
        if currentQuestionIndex == questionsAmount - 1 { // переход в "Результат квиза"
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let alert = AlertModel(
                title: "Этот раунд окончен!",
                message: "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыграных квизов: \(statisticService?.gamesCount ?? 1) \n Рекорд: \(statisticService?.bestGame.correct ?? correctAnswers)/\(statisticService?.bestGame.total ?? questionsAmount) (\(statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%",
                buttonText: "Сыграть еще раз!") { [weak self] in
                guard let self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            
            alertDialog?.alertShow(model: alert)
            
        } else { // переход в "Вопрос показан"
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion() // используем ? при обращении к свойствам и методам опционального типа данных
        }
    }
    private func show(quiz result: QuizResultsViewModel) { // приватный метод показа результатов раунда квиза
        let alert = UIAlertController( // создание самого алерта
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
        
        alert.addAction(action) // добавление кнопки в алерт
        self.present(alert, animated: true, completion: nil)
    }
    
    private func changeStateButton(isEnabled: Bool){
    yesButton.isEnabled  = isEnabled
    noButton.isEnabled = isEnabled
        
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    private func showLoadingIndicator() { // аргумента нет и данныен не возвращает
        activityIndicator.isHidden = false // индикатор загрузки не скрыт
        activityIndicator.startAnimating() // запуск анимации
    }
    private func hideLoadingIndicator (){
        activityIndicator.isHidden = true // индикатор загрузки скрыт
        activityIndicator.stopAnimating() // стоп анимации
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert = AlertModel(
            title: "Ошибка  ",
            message: message,
            buttonText: "Попробовать еще раз!") { [weak self] in
                guard let self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        alertDialog?.alertShow(model: alert)
    }
    // MARK: - IBActions
    // обработка нажатия кнопок Да/Het пользователем
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
        changeStateButton(isEnabled: false)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
        changeStateButton(isEnabled: false)
    }
}
