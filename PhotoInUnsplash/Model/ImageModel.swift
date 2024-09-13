//
//  ImageModel.swift
//  PhotoInUnsplash
//
//  Created by Паша Настусевич on 12.09.24.
//

import Foundation

struct ImageModel: Codable {

    let id: String
    let createdAt: String
    let downloads: Int
    let urls: URLs
    let user: User
    let location: Location?
    
    enum CodingKeys: String, CodingKey {
        case id, urls, user, location, downloads
        case createdAt = "created_at"
    }
}

struct URLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Codable {
    let name: String
}

struct Location: Codable {
    let name: String?
    let city: String? 
    let country: String?
}
