import UIKit
import Foundation

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    // MARK: ПЕРЕМЕННЫЕ
    
    private let questions: [QuizQuestion] = [ // переменная-массив со списком вопросов
        QuizQuestion (
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer:true),
        QuizQuestion (
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion (
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion (
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion (
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion (
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion (
            image:"Old",
            text:"Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
            
        ),
        QuizQuestion (
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion (
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion (
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        )
    ] // переменная-массив со списком вопросов
    private var currentQuestionIndex = 0 // переменная с индексом текущего вопроса (начальная)
    private var correctAnswers = 0 // переменная со счетчиком правильных ответов (начальная)
    
    // MARK: СТРУКТУРЫ
    // создание mock-данных
    struct QuizQuestion { // структура вопроса
        let image: String // название картинки афиши/фильма
        let text: String // вопрос
        let correctAnswer: Bool // правильный ответ на вопрос
    }
    struct QuizStepViewModel { // структура вью модели "Вопрос показан"
        let image: UIImage // картинка
        let question: String // вопрос
        let questionNumber: String // счетчик вопросов
    }
    struct QuizResultsViewModel { // структура вью модели "Результат квиза"
        let title: String // заголовок алерта
        let text: String  // количество набранных очков
        let buttonText: String // текст кнопки алерта
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex] // вопрос из массива-вопросов по индексу
        show(quiz: convert(model: currentQuestion)) // показ первого вопроса после конвертации вью модели
    }
    
    // MARK: МЕТОДЫ
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel { //приватный метод конвертации, который возвращает вью модель для главного экрана
        let questionStep = QuizStepViewModel (
            image: UIImage(named: model.image) ?? UIImage(), // инициализация картинки
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
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
        imageView.layer.cornerRadius = 20
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            dispatch()
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            dispatch()
        }
        
    }
    private func dispatch() { // приватный метод-диспетчеризации позволяет откладывать выолнение функции на 1 сек
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults () { // приватный метод перехода в один из сценариев
        if currentQuestionIndex == questions.count - 1 { // переход в "Результат квиза"
            let text = "Ваш результат: \(correctAnswers)/10"
            show(quiz:QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз"))
        } else { // переход в "Вопрос показан"
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            show(quiz: convert(model: nextQuestion))}
    }
    
    private func show(quiz result: QuizResultsViewModel) { // приватный метод показа результатов раунда квиза
        let alert = UIAlertController( // создание алерта
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            self.show(quiz: self.convert(model: firstQuestion))
        }
        
        alert.addAction(action) // добавление кнопки в алерт
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: БЛОК С АННОТАЦИЕЙ
    // подключение к интерфейсу
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // обработка нажатия кнопок Да/Het пользователем
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
        yesButton.isEnabled = false
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
        noButton.isEnabled = false
    }
}

