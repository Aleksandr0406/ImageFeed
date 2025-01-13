//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by 1111 on 11.12.2024.
//

import Foundation
import UIKit

struct AlertViewModel {
    var title: String
    var message: String
    var buttonText: String
}

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    func presentAlert(alert data: AlertViewModel) {
        guard let delegate = delegate
        else {
            print("AlertPresenter: Cant rewrite delegate into delegate")
            return
        }
        
        let alert = UIAlertController(
            title: data.title,
            message: data.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: data.buttonText,
            style: .default
        ) { [weak self] _ in
            guard self != nil else {
                print("AlertPresenter: action")
                return
            }
        }
        
        alert.addAction(action)
        delegate.present(alert, animated: true)
    }
}
