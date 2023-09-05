//
//  APICaller.swift
//  Pokemon
//
//  Created by Begüm Tüzüner on 31.07.2023.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    private init(){
        
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    func fetchPosts(completion: @escaping (Result<[Card], Error>) -> Void) {
        let apiURLString = "https://api.pokemontcg.io/v1/cards?hp=gte99"

        guard let url = URL(string: apiURLString) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do{
                let result = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(result.cards))
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}



