//
//  SearchResponse.swift
//  Pokemon
//
//  Created by Begüm Tüzüner on 31.07.2023.
//

import Foundation

struct SearchResponse: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let id: String
    let name: String
    let nationalPokedexNumber: Int
    let imageUrl: String
    let imageUrlHiRes: String
    let types: [String]
    let supertype: String
    let subtype: String?
    let ability: Ability?
    let hp: String
    let retreatCost: [String]?
    let convertedRetreatCost: Int?
    let number: String
    let artist: String
    let rarity: String?
    let series: String
    let set: String?
    let setCode: String
    let text: [String]?
    let attacks: [Attack]?
    let weaknesses: [Weakness]
}

struct Ability: Codable {
    let name: String
    let text: String?
    let type: String
}

struct Attack: Codable {
    let cost: [String]
    let name: String
    let text: String?
    let damage: String
    let convertedEnergyCost: Int
}

struct Weakness: Codable {
    let type: String
    let value: String
}

