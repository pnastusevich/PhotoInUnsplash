//
//  LikesCollectionViewCell.swift
//  PhotoInUnsplash
//
//  Created by Паша Настусевич on 12.09.24.
//

import UIKit
import SDWebImage

class LikesCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "LikesCollectionViewCell"
    
    private var myImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var likedPhoto: LikedPhoto! {
        didSet {
            let authorName = likedPhoto.authorName
            userNameLabel.text = authorName
            
            let photoUrl = likedPhoto.imageUrl
            guard let url = URL(string: photoUrl) else { return }
            myImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        contentView.addSubview(myImageView)
        contentView.addSubview(userNameLabel)
        setConstraint()
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate(
            [
        myImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        myImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        myImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
     
        userNameLabel.topAnchor.constraint(equalTo: myImageView.bottomAnchor),
        userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        userNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
