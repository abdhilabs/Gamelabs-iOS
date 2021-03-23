//
//  SearchViewController.swift
//  Gamelabs
//
//  Created by Abdhi on 04/03/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchGames: UISearchBar!
    @IBOutlet weak var tableGames: UITableView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    private let vm = SearchViewModel()
    private var games = [Game]()
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gamelabs"
        hideProgressView()
        searchGames.delegate = self
        tableGames.dataSource = self
        tableGames.delegate = self
        tableGames.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    private func loadSearchGames(_ query: String) {
        self.progressBar.startAnimating()
        vm.searchGames(textQuery: query) { (result) in
            switch result {
                case .success(let game):
                    self.games = game
                    self.tableGames.reloadData()
                    self.tableGames.isHidden = false
                    self.hideProgressView()
                    if self.games.isEmpty { self.messageGameEmpty("Game doesn't exist.") }
                case .failure(let error):
                    self.hideProgressView()
                    print("Error on: \(error.localizedDescription)")
            }
        }
    }
    private func hideProgressView() {
        self.progressBar.stopAnimating()
        self.progressBar.hidesWhenStopped = true
    }
}

extension SearchViewController: UITableViewDataSource {
    
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detail.idGame = games[indexPath.row].id
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tableGames.isHidden = true
        loadSearchGames(searchBar.text ?? "")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
        }
    }
}
