import UIKit
import Foundation

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var presenter: MovieQuizPresenter! // создаем экземпляр класса MovieQuizPresenter
    var alertDialog: AlertPresenter? // создаем экземпляр клаcса AlertPresenter
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        presenter = MovieQuizPresenter(viewController: self)
        presenter.viewController = self
        imageView.layer.cornerRadius = 20
        alertDialog = AlertPresenter(alertController: self)
        showLoadingIndicator()
    }
    // MARK: - IBActions
    // нажатие кнопки "Да"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        changeStateButton(isEnabled: false)
    }
    
    // нажатие кнопки "Нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        changeStateButton(isEnabled: false)
    }
    
    // MARK: - Methods
    // показ сконверитированной модели вопроса
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // показ результатов раунда квиза
    func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController( // создание алерта
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard self != nil else {
                return
            }
        }
        alert.addAction(action) // добавление кнопки в алерт
        present(alert, animated: true, completion: nil)
        presenter.restartGame()
    }
    
    // показ рамки
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    // скрытие рамки
    func hideBorder() {
        self.imageView.layer.borderWidth = 0
    }
    
    // показ индикатора загрузки
    func showLoadingIndicator() {
        activityIndicator.startAnimating() // запуск анимации
    }
    
    // скрытие индикатора загрузки
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating() // стоп анимации
    }
    
    // показ сетевой ошибки
    func showNetworkError(message: String) { 
        hideLoadingIndicator() // скрываем индикатор загрузки
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self else {
                    return
                }
                self.presenter.restartGame()
            }
        alertDialog?.alertShow(model: alert)
    }
    
    // изменение состояния кнопок: блокировка и разблокировка
    func changeStateButton(isEnabled: Bool) {
        yesButton.isEnabled  = isEnabled
        noButton.isEnabled = isEnabled
    }
}

