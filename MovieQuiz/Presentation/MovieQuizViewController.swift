import UIKit
import Foundation

final class MovieQuizViewController: UIViewController {
// MARK: - Lifecycle
    
// ПЕРЕМЕННЫЕ

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

//СТРУКТУРЫ

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
       let title: String
       let text: String
       let buttonText: String
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        // берём текущий вопрос из массива вопросов по индексу текущего вопроса
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }

// МЕТОДЫ

    private func convert(model: QuizQuestion) -> QuizStepViewModel { //приватный метод конвертации, который возвращает вью модель для главного экрана
        let questionStep = QuizStepViewModel (
        image: UIImage(named: model.image) ?? UIImage(),
        question: model.text,
        questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    return questionStep
    }

    private func show(quiz step: QuizStepViewModel) { //приватный метод вывода на экран вопроса, который принимает на вход вью моде
      imageView.image = step.image
      textLabel.text = step.question
      counterLabel.text = step.questionNumber
    }
    
    
    // БЛОК С АННОТАЦИЕЙ

    @IBOutlet weak var imageView: UIImageView! // подключение к интерфейсу
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
    }
}
/* Логика показа первого экрана:
 берем первый questions
 при ответе на вопрос увеличиваем currentQuestionIndex
 берем текущий вопрос let currentQuestion = questions[currentQuestionIndex]
 готовим данные для отображения convert(model: QuizQuestion)
 показываем вопрос на экране func show(quiz step: QuizStepViewModel)
 */




