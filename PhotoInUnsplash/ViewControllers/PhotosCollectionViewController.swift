//
//  PhotosCollectionViewController.swift
//  PhotoInUnsplash
//
//  Created by Паша Настусевич on 12.09.24.
//

import UIKit

final class PhotosCollectionViewController: UICollectionViewController {
    
    let networkManager = NetworkManager.shared
    
    private var timer: Timer?
    private var photos: [ImageModel] = []
    private var refreshControl = UIRefreshControl()
    
    // UICollectionViewDelegateFlowLayout
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupSearchBar()
        setupEnterLabel()
        setupSpinner()
        downloadsRandomImage()
    }
       
    // MARK: - UICollecionViewDataSource, UICollecionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = photos.count != 0
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId,
                                                      for: indexPath) as! PhotosCell
        let unspashPhoto = photos[indexPath.item]
        cell.configureCell(unsplashPhoto: unspashPhoto)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedPhoto = photos[indexPath.item]
            let detailVC = ImageDetailViewController()
        
            detailVC.imageUrl = selectedPhoto.urls.regular
            detailVC.authorName = selectedPhoto.user.name
            detailVC.creationDate = selectedPhoto.createdAt
            detailVC.downloads = selectedPhoto.downloads
            detailVC.location = selectedPhoto.location?.name
            
            navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Setup UI 
extension PhotosCollectionViewController {
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        refreshControl.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refreshPhotos() {
            downloadsRandomImage()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            }
        }
    
    private func setupEnterLabel() {
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        enterSearchTermLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 50).isActive = true
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    private func setupNavigationBar() {
        title = "Photos"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSearchBar() {
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        navigationItem.hidesSearchBarWhenScrolling = false
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }
}

// MARK: - Network
extension PhotosCollectionViewController {
    private func downloadsRandomImage() {
        networkManager.fetchRandomData { result in
            switch result {
            case .success(let images):
                self.photos = []
                self.photos = images
                self.collectionView.reloadData()
                self.spinner.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func downloadsImageForSearch(searchText: String) {
        networkManager.fetchData(searchText) { result in
        switch result {
        case .success(let images):
            self.photos = []
            self.photos = images
            self.spinner.stopAnimating()
            self.collectionView.reloadData()
        case .failure(let error):
            print(error)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.spinner.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1,repeats: false, block: { (_) in
            self.downloadsImageForSearch(searchText: searchText)
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let totalPadding = sectionInserts.left * (itemsPerRow + 1)
            let availableWidth = collectionView.frame.width - totalPadding
            let itemWidth = availableWidth / itemsPerRow
            return CGSize(width: itemWidth, height: itemWidth)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            sectionInserts
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            sectionInserts.left
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            sectionInserts.left
        }
    }
