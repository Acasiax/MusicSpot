//
//  API.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import Foundation

enum MediaType: String {
    case music = "music"
    case movie = "movie"
    case software = "software"
    case podcast = "podcast"
    case ebook = "ebook"
}


struct MediaURL {
    static let base = "https://itunes.apple.com/search?"
    
    static func buildURL(term: String, mediaType: MediaType, country: String = "KR", limit: Int = 20) -> String {
        let urlEncodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "\(base)term=\(urlEncodedTerm)&country=\(country)&media=\(mediaType.rawValue)&limit=\(limit)"
    }
}



struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let trackName: String
    let artistName: String
    let primaryGenreName: String?
    let releaseDate: String?
    let longDescription: String?
    let trackPrice: Double?
    let artworkUrl100: String?
}

struct SoftwareResponse: Codable {
    let results: [Software]
}

struct Software: Codable {
    let trackName: String  // 앱 이름
    let artistName: String //개발자 이름
    let description: String?
    let price: Double?
    let artworkUrl100: String?
    let averageUserRating: Double?
    let primaryGenreName: String?
    let supportedDevices: [String]?
    let version: String?
}

struct PodcastResponse: Codable {
    let results: [Podcast]
}

struct Podcast: Codable {
    let collectionName: String
    let artistName: String
    let description: String?
    let primaryGenreName: String?
    let feedUrl: String?
}

struct MusicResponse: Codable {
    let results: [Music]
}

struct Music: Codable {
    let trackName: String
    let artistName: String
    let collectionName: String?
    let primaryGenreName: String?
    let releaseDate: String?
    let trackPrice: Double?
    let artworkUrl100: String?
    let previewUrl: String?
}

struct EbookResponse: Codable {
    let results: [Ebook]
}

struct Ebook: Codable {
    let trackName: String
    let artistName: String
    let description: String?
    let price: Double?
    let artworkUrl100: String?
    let averageUserRating: Double?
    let primaryGenreName: String?
    let releaseDate: String?
}
