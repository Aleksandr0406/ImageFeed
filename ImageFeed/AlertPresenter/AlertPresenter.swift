//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by 1111 on 11.12.2024.
//

import Foundation
import UIKit

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    func presentAlert() {
        guard let delegate = delegate
        else {
            print("AlertPresenter: Cant rewrite delegate into delegate")
            return
        }
        
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "Ok",
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
