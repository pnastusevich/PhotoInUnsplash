//
//  SavedImageModel.swift
//  PhotoInUnsplash
//
//  Created by Паша Настусевич on 12.09.24.
//

import Foundation

final class SavedImageModel {
    
    var savedImage = UnsplashPhoto()
    
    static let shared = SavedImageModel()
    
    private init() {}
    
}

