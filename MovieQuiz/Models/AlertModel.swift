//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 03.02.2025.
//

import Foundation

struct AlertModel { 
    let title: String // заголовок алерта
    let message: String // сообщение алерта
    let buttonText: String // текст для кнопки алерта
    let completion: (() -> Void)? // замыкание для действия по кнопке алерта
}
