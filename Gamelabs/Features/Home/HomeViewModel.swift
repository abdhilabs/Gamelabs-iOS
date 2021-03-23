//
//  HomeViewModel.swift
//  Gamelabs
//
//  Created by Abdhi on 05/03/21.
//

import Foundation

class HomeViewModel {
  private let networkManager: NetworkManager
  init(networkManager: NetworkManager = NetworkManager()) {
    self.networkManager = networkManager
  }
  func loadGames(completion: @escaping (Result<[Game], GameError>) -> Void) {
    self.networkManager.getGames { (result) in
      switch result {
        case .success(let response):
          completion(.success(response.results))
        case .failure(let error):
          completion(.failure(error))
      }
    }
  }
}
