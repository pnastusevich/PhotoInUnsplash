//
//  LikesCollectionViewController.swift
//  PhotoInUnsplash
//
//  Created by Паша Настусевич on 12.09.24.
//

import UIKit

final class LikesCollectionViewController: UICollectionViewController {
    
    var likedPhotos: [LikedPhoto] = []
    
    let likedPhotosStorageManager = LikedPhotosStorageManager.shared
    let networkManager = NetworkManager.shared
    
    private let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't add a photos yet"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupEnterLabel()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedPhotos = likedPhotosStorageManager.getLikedPhotos()
        collectionView.reloadData()
    }
}
    // MARK: - Setup UI
extension LikesCollectionViewController {
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(LikesCollectionViewCell.self,
                                forCellWithReuseIdentifier: LikesCollectionViewCell.reuseId
        )
        collectionView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
    }
    
    private func setupEnterLabel() {
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        enterSearchTermLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 50).isActive = true
    }
    
    private func setupNavigationBar() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = true
    }
}
        
        // MARK: - UICollectionViewDataSource, UICollecionViewDelegate
extension LikesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = likedPhotos.count != 0
        return likedPhotos.count
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesCollectionViewCell.reuseId, for: indexPath) as! LikesCollectionViewCell

        let likedPhoto = likedPhotos[indexPath.item]
        cell.likedPhoto = likedPhoto
        return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        let selectedPhoto = likedPhotos[indexPath.item]
        let detailVC = ImageDetailViewController()
        detailVC.imageUrl = selectedPhoto.imageUrl
        detailVC.authorName = selectedPhoto.authorName
        detailVC.creationDate = selectedPhoto.creationDate
        detailVC.downloads = selectedPhoto.downloads
        detailVC.location = selectedPhoto.location
            
        navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
extension LikesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/3 - 5, height: width/3 - 5)
    }
}
