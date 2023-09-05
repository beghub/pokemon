//
//  UserDefaults.swift
//  Pokemon
//
//  Created by Begüm Tüzüner on 3.08.2023.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let favoritesKey = "FavoriteCards"

    private init() {}

    // Get favorite cards from UserDefaults
    func getFavoriteCards() -> [Card] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favoriteCards = try? JSONDecoder().decode([Card].self, from: data) else {
            return [] // Return an empty array if no favorite cards found or decoding fails
        }
        return favoriteCards
    }
    
    // Save favorite cards to UserDefaults
        func setFavoriteCards(_ favoriteCards: [Card]) {
            do {
                let data = try JSONEncoder().encode(favoriteCards)
                UserDefaults.standard.set(data, forKey: favoritesKey)
            } catch {
                print("Error encoding favorite cards: \(error)")
            }
        }
}
