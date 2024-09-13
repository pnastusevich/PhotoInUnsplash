//
//  StorageManager.swift
//  PhotoInUnsplash
//
//  Created by Паша Настусевич on 12.09.24.
//

import Foundation

final class LikedPhotosStorageManager {
    static let shared = LikedPhotosStorageManager()
    
    private init() {}
    
    private var likedPhotos: [LikedPhoto] = []
    
    func addPhoto(_ photo: LikedPhoto) {
        likedPhotos.append(photo)
    }
    
    func isPhotoLiked(photo: LikedPhoto) -> Bool {
        return likedPhotos.contains { $0.imageUrl == photo.imageUrl && $0.authorName == photo.authorName && $0.creationDate == photo.creationDate }
    }
    
    func removePhoto(_ photo: LikedPhoto) {
        if let index = likedPhotos.firstIndex(where: { $0.imageUrl == photo.imageUrl && $0.authorName == photo.authorName && $0.creationDate == photo.creationDate}) {
            likedPhotos.remove(at: index)
        }
    }
    
    func getLikedPhotos() -> [LikedPhoto] {
        return likedPhotos
    }
}
