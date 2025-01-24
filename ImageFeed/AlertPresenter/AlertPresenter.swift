//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by 1111 on 11.12.2024.
//

import Foundation
import UIKit

struct AlertViewModel {
    let title: String
    let message: String
    let buttonText: String
}

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    func presentAlert(alert data: AlertViewModel) {
        guard let delegate = delegate
        else { return }
        
        let alert = UIAlertController(
            title: data.title,
            message: data.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: data.buttonText,
            style: .default
        )
        
        alert.addAction(action)
        delegate.present(alert, animated: true)
    }
}
