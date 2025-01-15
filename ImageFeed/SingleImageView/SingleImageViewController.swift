//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by 1111 on 01.11.2024.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var singleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIBlockingProgressHUD.show()
        singleImage.kf.setImage(with: ImagesListViewController.urlFull) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else {
                print("SingleImageViewController: viewDidLoad/ guard let self ")
                return
            }
            
            switch result {
            case .success(let imageResult):
                singleImage.frame.size = imageResult.image.size
                rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                print("SingleImageViewController: viewDidLoad()/ case .failure")
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        if imageSize.width != 0 && imageSize.height != 0 {
            let hScale = visibleRectSize.width / imageSize.width
            let vScale = visibleRectSize.height / imageSize.height
            let scale = max(hScale, vScale)
            scrollView.minimumZoomScale = scale
            scrollView.maximumZoomScale = 1.25
            scrollView.setZoomScale(scale, animated: false)
        } else {
            print("Деление на ноль")
        }
        
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    @IBAction private func didTapBackwardsButt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = singleImage.image else {
            print("SingleImageViewController: func didTapShareButton(...)")
            return
        }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImage
    }
}
