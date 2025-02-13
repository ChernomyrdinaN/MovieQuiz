//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 03.02.2025.
//

import Foundation

struct AlertModel { // структура алерта
    let title: String // текст заголовка алерта
    let message: String // текст сообщения алерта
    let buttonText: String // текст кнопки алерта
    var complition: (() -> Void)? // замыкание для действия по кнопке алерта
}
