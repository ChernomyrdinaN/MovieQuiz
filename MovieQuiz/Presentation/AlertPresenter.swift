//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Наталья Черномырдина on 04.02.2025.
//

import UIKit

final class AlertPresenter {
    
    // MARK: - Properties
    private weak var alertController: UIViewController?
    
    init(alertController: UIViewController?) {
        self.alertController = alertController
    }
    
    //MARK: - Methods
    func alertShow(model: AlertModel) {
        let alert = UIAlertController( // инициализация
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { [weak self] _ in
            guard self != nil else { return }
            model.completion?()
        }
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "universalAlert"
        alertController?.present(alert, animated: true, completion: nil)
    }
}




