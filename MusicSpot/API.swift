//
//  API.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import Foundation

struct MusicURL {
    static let base = "https://itunes.apple.com/search?"
    
    static func buildURL(term: String, country: String = "KR", media: String = "music", limit: Int = 10) -> String {
        let urlEncodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "\(base)term=\(urlEncodedTerm)&country=\(country)&media=\(media)&limit=\(limit)"
    }
}



struct MusicResponse: Codable {
    let results: [Music]
}

struct Music: Codable {
    let trackName: String
    let artistName: String
    let collectionName: String?
    let artworkUrl100: String?
}
