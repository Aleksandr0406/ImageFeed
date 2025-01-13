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
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        print("visibleRectSize: width & height", visibleRectSize.width, visibleRectSize.height)
        let imageSize = image.size
        print("imageSize: width & height", imageSize.width, imageSize.height)
        
        if imageSize.width != 0 && imageSize.height != 0 {
            let hScale = visibleRectSize.width / imageSize.width
            print("hScale", hScale)
            let vScale = visibleRectSize.height / imageSize.height
            print("vScale", vScale)
            let scale = max(hScale, vScale)
            print("scale", scale)
            scrollView.minimumZoomScale = scale
            scrollView.maximumZoomScale = 1.25
            scrollView.setZoomScale(scale, animated: false)
        } else {
            print("Деление на ноль")
        }
        
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        print("newContentSize: width & hegth", newContentSize.width, newContentSize.height)
        let x = (newContentSize.width - visibleRectSize.width) / 2
        print("x", x)
        let y = (newContentSize.height - visibleRectSize.height) / 2
        print("y", y)
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImage
    }
}
