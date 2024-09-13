//
//  PhotosCollectionViewCell.swift
//  PhotoInUnsplash
//
//  Created by Паша Настусевич on 12.09.24.
//

import UIKit
import SDWebImage

final class PhotosCell: UICollectionViewCell {
    
    static let reuseId = "PhotosCell"
    
     let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotoImageView()
    }
    
    func configureCell(unsplashPhoto: ImageModel) {
        photoImageView.image = nil
        let photoUrl = unsplashPhoto.urls.small
        guard let url = URL(string: photoUrl) else { return }
        photoImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func setupPhotoImageView() {
        contentView.addSubview(photoImageView)
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
