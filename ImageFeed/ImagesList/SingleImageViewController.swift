//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by 1111 on 01.11.2024.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage?
    
    @IBOutlet private var singleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImage.image = image
    }
    
    @IBAction func didTapBackwardsButt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
