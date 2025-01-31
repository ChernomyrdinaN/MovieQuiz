import UIKit
import Foundation

final class MovieQuizViewController: UIViewController {
    // MARK: - АУТЛЕТЫ
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: ПЕРЕМЕННЫЕ
    private var currentQuestionIndex = 0 // переменная с индексом текущего вопроса (начальная)
    private var correctAnswers = 0 // переменная со счетчиком правильных ответов (начальная)
    private let questionsAmount: Int = 10 // переменная-количество вопросов
    private var questionFactory: QuestionFactory = QuestionFactory() // переменная от фабрики вопросов
    private var currentQuestion: QuizQuestion? // переменная-вопрос показанный пользователю
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        if let firstQuestion = questionFactory.requestNextQuestion() { // рапаковка вопроса-опционала
            currentQuestion = firstQuestion // каждый сгенерированный вопрос сохраняем в свойство
            show(quiz: convert(model: firstQuestion)) // показ вопроса от фабрики
        }
    }
        
        // MARK: МЕТОДЫ
        private func convert(model: QuizQuestion) -> QuizStepViewModel { //приватный метод конвертации, который возвращает вью модель для главного экрана
            let questionStep = QuizStepViewModel (
                image: UIImage(named: model.image) ?? UIImage(), // инициализация картинки
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
                guard let self = self else {return}
                self.showNextQuestionOrResults()
                self.imageView.layer.borderWidth = 0
                self.yesButton.isEnabled = true
                self.noButton.isEnabled = true
            }
        }
        
    private func showNextQuestionOrResults () { // приватный метод перехода в один из сценариев
        if currentQuestionIndex == questionsAmount - 1 { // переход в "Результат квиза"
            let text = "Ваш результат: \(correctAnswers)/10"
            show(quiz:QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз"))
        } else { // переход в "Вопрос показан"
            currentQuestionIndex += 1
            if let  nextQuestion = questionFactory.requestNextQuestion() { // рапаковка вопроса-опционала
                currentQuestion =  nextQuestion// каждый сгенерированный вопрос сохраняем в свойство
                show(quiz: convert(model:nextQuestion)) // показ вопроса от фабрики
            }
            
        }
    }
        private func show(quiz result: QuizResultsViewModel) { // приватный метод показа результатов раунда квиза
            let alert = UIAlertController( // создание алерта
                title: result.title,
                message: result.text,
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else {return}
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                if let firstQuestion = self.questionFactory.requestNextQuestion() {
                    self.currentQuestion = firstQuestion
                    self.show(quiz: self.convert(model: firstQuestion))
                }
            }
            
            alert.addAction(action) // добавление кнопки в алерт
            self.present(alert, animated: true, completion: nil)
        }
        
        // MARK: ЭКШЕНЫ
        // обработка нажатия кнопок Да/Het пользователем
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
            yesButton.isEnabled = false
        }
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
            noButton.isEnabled = false
        }
    }
    

