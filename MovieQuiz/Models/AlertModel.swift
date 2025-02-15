//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 03.02.2025.
//

import Foundation

struct AlertModel { 
    var title: String
    var message: String
    var buttonText: String
    var completion: (() -> Void)?
}
