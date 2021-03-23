//
//  FavouriteViewController.swift
//  Gamelabs
//
//  Created by Abdhi on 20/03/21.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableFavourite: UITableView!
    
    private lazy var gameProvider: GameProvider = { return GameProvider() }()
    private var games = [FavouriteModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        loadFavourite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gamelabs"
        tableFavourite.dataSource = self
        tableFavourite.delegate = self
        tableFavourite.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
    }
    
    private func loadFavourite() {
        gameProvider.getAllFavouriteGame { (game) in
            DispatchQueue.main.async {
                self.games = game
                self.tableFavourite.reloadData()
                if self.games.isEmpty { self.messageGameEmpty("You doesn't have game favourite") }
            }
        }
    }
}

extension FavouriteViewController: UITableViewDataSource {
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

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
        guard let idGame = games[indexPath.row].id else {return}
        detail.idGame = Int(idGame)
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
