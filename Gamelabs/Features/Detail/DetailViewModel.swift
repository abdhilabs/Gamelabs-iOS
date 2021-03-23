//
//  DetailViewModel.swift
//  Gamelabs
//
//  Created by Abdhi on 06/03/21.
//

import Foundation

class DetailViewModel {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func loadGame(id: Int, completion: @escaping (Result<Game, GameError>) -> Void) {
        self.networkManager.getGame(id: id) { (result) in
            switch result {
            case .success(let game):
                completion(.success(game))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
