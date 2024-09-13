//
//  ImageDetailViewController.swift
//  PhotoInUnsplash
//
//  Created by Паша Настусевич on 12.09.24.
//

import UIKit

final class ImageDetailViewController: UIViewController {
    
    let likedPhotosStorageManager = LikedPhotosStorageManager.shared
    
    var imageUrl: String?
    var authorName: String?
    var creationDate: String?
    var location: String?
    var downloads: Int?
    
    // MARK: - UI Elements
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save,
                               target: self,
                               action: #selector(saveBarButtonTapped))
    }()
    
    private lazy var deleteBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash,
                               target: self,
                               action: #selector(deleteBarButtonTapped))
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var downloadsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

       override func viewDidLoad() {
           super.viewDidLoad()
           setupView()
           downloadImage()
       }
    
    // MARK: - NavigationItems action
    @objc private func saveBarButtonTapped() {
        let alertController = UIAlertController(title: "",
                                                message: "Photo will be added to the album",
                                                preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Done", style: .default) { (action) in
            self.imageSaving()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @objc private func deleteBarButtonTapped() {
        
        guard let imageUrl = imageUrl,
              let authorName = authorName,
              let creationDate = creationDate,
              let downloads = downloads,
              let location = location
        else { return }
        
        let likedPhoto = LikedPhoto(
            imageUrl: imageUrl,
            authorName: authorName,
            creationDate: creationDate,
            location: location,
            downloads: downloads
        )
             
        likedPhotosStorageManager.removePhoto(likedPhoto)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func imageSaving() {
        guard let imageUrl = imageUrl,
              let authorName = authorName,
              let creationDate = creationDate,
              let downloads = downloads,
              let location = location
        else { return }

        let likedPhoto = LikedPhoto(imageUrl: imageUrl,
                                    authorName: authorName,
                                    creationDate: creationDate,
                                    location: location,
                                    downloads: downloads
        )
        likedPhotosStorageManager.addPhoto(likedPhoto)
    }
       
    // MARK: - Network
    private func downloadImage() {
        guard let photoUrl = imageUrl, let url = URL(string: photoUrl) else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }
    
    private func convertDateString(isoDateString: String) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: isoDateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM yyyy, HH:mm"
            return outputFormatter.string(from: date)
            }
            return nil
        }
    }
    
    // MARK: - Setup UI
    extension ImageDetailViewController {
        private func setupView() {
            view.backgroundColor = .white
            
            guard let creationDate = creationDate else { return }
            guard let downloads = downloads else { return }
            let date = convertDateString(isoDateString: creationDate)
            dateLabel.text = "Created at: \(date ?? "Unknown")"
            authorLabel.text = "Author: \(authorName ?? "Unknown")"
            downloadsLabel.text = "Downloads: \(String(downloads))"
            locationLabel.text = "Location: \(location ?? "Unknown")"
         
            setupSubviews(imageView, authorLabel, dateLabel, downloadsLabel, locationLabel)
            setConstraint()
            setupNavigationBar()
        }
        
        func setupSubviews(_ subviews: UIView...) {
            subviews.forEach { subviews in
                view.addSubview(subviews)
            }
        }
        
        func setConstraint() {
            NSLayoutConstraint.activate(
                [
                    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                    imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
                    imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
                    
                    authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),

                    dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
                    
                    downloadsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    downloadsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
                    
                    locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    locationLabel.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 10)
                ]
            )
        }
        
        private func setupNavigationBar() {
            title = "Detail photo"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.rightBarButtonItems = [deleteBarButtonItem, addBarButtonItem]
            updateLikeButtonsState()
        }
        
        func updateLikeButtonsState() {

            guard let imageUrl = imageUrl,
                  let authorName = authorName,
                  let creationDate = creationDate,
                  let downloads = downloads,
                  let location = location
            else { return }
            
            let photoToCheck = LikedPhoto(imageUrl: imageUrl,
                                          authorName: authorName,
                                          creationDate: creationDate,
                                          location: location,
                                          downloads: downloads
            )
            
            if likedPhotosStorageManager.isPhotoLiked(photo: photoToCheck) {
                addBarButtonItem.isEnabled = false
                deleteBarButtonItem.isEnabled = true
            } else {
                addBarButtonItem.isEnabled = true
                deleteBarButtonItem.isEnabled = false
            }
            
        }
   }

