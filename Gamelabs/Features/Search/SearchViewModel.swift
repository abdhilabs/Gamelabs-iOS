//
//  SearchViewModel.swift
//  Gamelabs
//
//  Created by Abdhi on 07/03/21.
//

import Foundation

class SearchViewModel {
    
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
  func searchGames(textQuery: String, completion: @escaping (Result<[Game], GameError>) -> Void) {
        self.networkManager.searchGame(query: textQuery) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
