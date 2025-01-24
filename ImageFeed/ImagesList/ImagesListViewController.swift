//
//  ViewController.swift
//  ImageFeed
//
//  Created by 1111 on 24.10.2024.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var dateFormatterISO = ISO8601DateFormatter()
    private var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.loadNextPhotoPage() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                UIBlockingProgressHUD.dismiss()
                tableView.reloadData()
            case .failure:
                print("ImagesListViewController: func fetchPhotosNextPage ")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let testMode = ProcessInfo.processInfo.arguments.contains("testMode")
        
        if testMode {
            print("For TESTing")
        } else {
            guard let photosCount = presenter?.photosCount(),
                  indexPath.row == photosCount - 1 else { return }
            presenter?.loadNextPhotoPage()  { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    tableView.reloadData()
                case .failure:
                    print("ImagesListViewController: func fetchPhotosNextPage ")
                }
            }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photosCount = presenter?.photosCount() else { return 0 }
        return photosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        setupGradientView(imageListCell)
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}


extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell, complition: @escaping (Result<Bool, Error>) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        
        presenter?.changeLike(for: indexPath) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                UIBlockingProgressHUD.dismiss()
                complition(.success(data))
            case .failure:
                UIBlockingProgressHUD.dismiss()
                print("ImagesListViewController: func fetchPhotosNextPage ")
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.saveURLFull(for: indexPath)
        
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        guard let imageWidth = presenter?.widthCell(for: indexPath),
              let imageHeight = presenter?.heightCell(for: indexPath) else { return CGFloat() }
        
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

private extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let urlPhoto = presenter?.urlPhoto(for: indexPath) else { return }
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: urlPhoto,
                                   placeholder: UIImage(named: "PlaceholderForImage"),
                                   options: [.transition(.fade(1))]
        )
        { [weak self] _ in
            guard let self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        guard let createdAt = presenter?.createdAt(for: indexPath),
              let date = dateFormatterISO.date(from: createdAt)
        else { return }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "rus")
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        guard let likeImage = presenter?.likeImage(for: indexPath) else { return }
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func setupGradientView(_ cell: ImagesListCell) {
        let gradient = CAGradientLayer()
        guard let colorTop: UIColor = UIColor(named: "BlackGradientTop"),
              let colorBottom: UIColor = UIColor(named: "BlackGradientBottom") else { return }
        
        gradient.colors = [colorTop, colorBottom]
        gradient.frame = cell.gradientView.bounds
        cell.gradientView.layer.addSublayer(gradient)
    }
}



