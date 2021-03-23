//
//  HomeViewController.swift
//  Gamelabs
//
//  Created by Abdhi on 04/03/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableGame: UITableView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    private let vm = HomeViewModel()
    private var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gamelabs"
        tableGame.dataSource = self
        tableGame.delegate = self
        tableGame.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        observeGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func observeGames() {
        self.progress.startAnimating()
        vm.loadGames { [weak self] (result) in
            switch result {
                case .success(let data):
                    self?.games = data
                    self?.tableGame.reloadData()
                    self?.tableGame.isHidden = false
                    self?.hideProgressView()
                case .failure(let error):
                    self?.hideProgressView()
                    print("Error on: \(error.localizedDescription)")
            }
        }
    }
    private func hideProgressView() {
        self.progress.stopAnimating()
        self.progress.hidesWhenStopped = true
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else {
            fatalError("DequeueReusableCell failed while casting")
        }
        let game = games[indexPath.row]
        cell.setCellWithValuesOf(game)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detail.idGame = games[indexPath.row].id
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
