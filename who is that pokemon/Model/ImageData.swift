//
//  ImageData.swift
//  who is that pokemon
//
//  Created by Jozek Hajduk on 5/02/24.
//

import Foundation

struct ImageData: Codable {
    let sprites: Sprites
}

struct Sprites: Codable {
    let other: Other
    
    init(other: Other) {
        self.other = other
    }
}

struct Other: Codable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

