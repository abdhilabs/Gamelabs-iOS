//
//  NetworkManager.swift
//  Gamelabs
//
//  Created by Abdhi on 05/03/21.
//

import Foundation
import Alamofire

enum GameError: Error, CustomNSError {
    case networkError
    case apiError
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .networkError: return "No internet connection"
        case .decodingError: return "Failed to decode data"
        }
    }
}

class NetworkManager {
    
    let jsonDecoder = JSONDecoder()
    private let baseAPIURL = "https://api.rawg.io/api"
    
    func getGames(completion: @escaping(Swift.Result<GameResponse, GameError>) -> Void) {
        AF.request("\(baseAPIURL)/games").validate().responseJSON { json in
            switch json.result {
            case.failure :
                completion(.failure(.apiError))
            case .success(let jsonData):
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys) {
                    do {
                        let decodeData = try self.jsonDecoder.decode(GameResponse.self, from: jsonData)
                        completion(.success(decodeData))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                } else {
                    completion(.failure(.networkError))
                }
            }
        }
    }
    
    func getGame(id: Int, completion: @escaping (Swift.Result<Game, GameError>) -> Void) {
        AF.request("\(baseAPIURL)/games/\(id)").validate().responseJSON { json in
            switch json.result {
            case .failure :
                completion(.failure(.apiError))
            case .success(let jsonData):
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys) {
                    do {
                        let decodeData = try self.jsonDecoder.decode(Game.self, from: jsonData)
                        completion(.success(decodeData))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                } else {
                    completion(.failure(.networkError))
                }
            }
        }
    }
    
    func searchGame(query: String, completion: @escaping (Swift.Result<GameResponse, GameError>) -> Void) {
        let parameters: Parameters = [
            "search": query
        ]
        AF.request("\(baseAPIURL)/games", parameters: parameters).validate().responseJSON { json in
            switch json.result {
            case .failure:
                completion(.failure(.apiError))
            case .success(let jsonData):
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys) {
                    do {
                        let decodeData = try self.jsonDecoder.decode(GameResponse.self, from: jsonData)
                        completion(.success(decodeData))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                } else {
                    completion(.failure(.networkError))
                }
            }
        }
    }
}
