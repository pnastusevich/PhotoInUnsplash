//
//  NetworkManager.swift
//  PhotoInUnsplash
//
//  Created by Паша Настусевич on 12.09.24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(_ request: String, completion:  @escaping (Result<ImageModel, NetworkError>) -> Void) {
        let parametrs = self.prepareParametrs(request: request)
        guard let url = self.url(parametrs: parametrs)
        else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion(.failure(.noData))
                return
            }
            do {
                let images = try JSONDecoder().decode(ImageModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(images))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
    private func prepareParametrs(request: String?) -> [String: String] {
        var parametrs = [String: String]()
        parametrs["query"] = request
        parametrs["page"] = String(1)
        parametrs["per_page"] = String(30)
        
        return parametrs
    }
    
    private func url( parametrs: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = parametrs.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url
    }
    
    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID Civ7IvYLyqoWLcPh_hStEuS-stfD2d74fSpr1HzP2Os"
        return headers
    }
    
    
}
