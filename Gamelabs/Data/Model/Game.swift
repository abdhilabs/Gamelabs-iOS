//
//  Game.swift
//  Gamelabs
//
//  Created by Abdhi on 04/03/21.
//

import Foundation

struct GameResponse: Codable {
    
    let count: Int
    let results: [Game]
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
}

struct Game: Codable, Identifiable {
    
    let id: Int?
    let name: String?
    let description: String?
    let released: String?
    let backgroundImage: String?
    let ratingAverage: Double?
    
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description = "description_raw"
        case released
        case backgroundImage = "background_image"
        case ratingAverage = "rating"
        case genres
    }
    
    static private let dateTextFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter
    }()
    
    var posterUrl: URL? {
        return URL(string: backgroundImage ?? "")
    }
    
    var dateText: String {
        guard let releaseDate = self.released, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return "Release on: " + Game.dateTextFormatter.string(from: date)
    }
    
    var ratingText: String {
        let rating = Int(ratingAverage ?? 0.0)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "⭐️"
        }
        return ratingText
    }
    
    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/5"
    }
    
    var genreText: String {
        var genre = [String]()
        if genres != nil {
            for i in genres! {
                genre.append(i.name)
            }
        }
        return genre.joined(separator: " / ")
    }
}

struct Genre: Codable, Identifiable {
    
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
