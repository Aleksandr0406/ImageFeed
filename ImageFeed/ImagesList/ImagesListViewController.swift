//
//  ViewController.swift
//  ImageFeed
//
//  Created by 1111 on 24.10.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let currentDate = Date()
    private var photos: [Photo] = []
//    private let photosName: [String] = Array(0...19).map{ "\($0)"}
    private let service: ImagesListService = .shared
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "rus")
        return formatter
    }()
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        service.fetchPhotosNextPage { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newPhoto):
                photos += newPhoto
                tableView.reloadData()
            case .failure:
                print("ImagesListViewController: func fetchPhotosNextPage ")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
//            guard
//                let viewController = segue.destination as? SingleImageViewController,
//                let indexPath = sender as? IndexPath
//            else {
//                print("ImagesListViewController: func prepare(...)")
//                assertionFailure("Invalid segue destination")
//                return
//            }
//            
//            let image = UIImage(named: photosName[indexPath.row])
//            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return photosName.count
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("ImagesListViewController: func tableView(...) Не смогли привести к необходимому типу")
            return UITableViewCell()
        }
        
        setupGradientView(imageListCell)
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

private extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            print("ImagesListViewController: func configCell(...)")
//            return
//        }
        
//        cell.cellImage.image = image
        cell.cellImage.kf.setImage(with: photos[indexPath.row].urls?.regular)
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "Like_button_on") : UIImage(named: "Like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        
    }
    
    func setupGradientView(_ cell: ImagesListCell) {
        let gradient = CAGradientLayer()
        guard let colorTop: UIColor = UIColor(named: "BlackGradientTop"),
              let colorBottom: UIColor = UIColor(named: "BlackGradientBottom") else {
            print("ImagesListViewController: func setupGradientView(...)")
            return
        }
        
        gradient.colors = [colorTop, colorBottom]
        gradient.frame = cell.gradientView.bounds
        cell.gradientView.layer.addSublayer(gradient)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
        //        guard let image = UIImage(named: photosName[indexPath.row]) else {
        //            print("ImagesListViewController: func tableView(...)")
        //            return 0
        //        }
        //
        //        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        //        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        //        let imageWidth = image.size.width
        //        let scale = imageViewWidth / imageWidth
        //        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        //        return cellHeight
        //    }
    }
}

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == photos.count - 1 else { return }
        service.fetchPhotosNextPage() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newPhoto):
                photos += newPhoto
                tableView.reloadData()
            case .failure:
                print("ImagesListViewController: func fetchPhotosNextPage ")
            }
        }
    }
}
