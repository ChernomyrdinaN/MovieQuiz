import UIKit
import Foundation

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var presenter: MovieQuizPresenter! // создаем экземпляр класса MovieQuizPresenter
    var alertDialog: AlertPresenter? // создаем экземпляр клааса AlertPresenterMM
    var statisticService: StatisticServiceProtocol? // создаем экземпляр класса StatisticService
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        presenter.viewController = self
        imageView.layer.cornerRadius = 20
        statisticService = StatisticService()
        alertDialog = AlertPresenter(alertController: self) // инициализация
        showLoadingIndicator() // показ индикатора
    }
    
    // MARK: - Methods
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating() // запуск анимации
    } // показ индикатора загрузки
   
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating() // стоп анимации
    } // скрытие индикатора загрузки
    
    func showNetworkError(message: String) { // метод показа алерта
        hideLoadingIndicator() // скрываем индикатор загрузки
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self else { return }
                self.presenter.restartGame()
                //self.questionFactory?.loadData() // попытка загрузки данных
            }
        alertDialog?.alertShow(model: alert) //
        
    } // показ сетевой ошибки
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    } // показ сконверитированной модели вопроса
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
           imageView.layer.masksToBounds = true
           imageView.layer.borderWidth = 8
           imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
       } // рамка
    
    func hideBorder() {
        self.imageView.layer.borderWidth = 0
    } // скрытие рамки
    
    func changeStateButton(isEnabled: Bool) {
        yesButton.isEnabled  = isEnabled
        noButton.isEnabled = isEnabled
    } // изменение состояния кнопок: блокировка и разблокировка
    
    private func show(quiz result: QuizResultsViewModel) {
        statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        let alert = UIAlertController( // создание самого алерта
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard self != nil else { return }
        }
        alert.addAction(action) // добавление кнопки в алерт
        self.present(alert, animated: true, completion: nil)
        self.presenter.restartGame()
    } // показ результатов раунда квиза
    
    // MARK: - IBActions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        changeStateButton(isEnabled: false)
    } // нажатие кнопки "Да"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        changeStateButton(isEnabled: false)
    } // нажатие кнопки "Нет"
}

