//
//  DetailViewController.swift
//  Gamelabs
//
//  Created by Abdhi on 05/03/21.
//

import UIKit
import Toast_Swift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageBanner: UIImageView!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var textRating: UILabel!
    @IBOutlet weak var textCategory: UILabel!
    @IBOutlet weak var textReleaseDate: UILabel!
    @IBOutlet weak var textDescription: UILabel!
    
    private let vm = DetailViewModel()
    private var isFavourite = false
    var idGame: Int?
    
    private lazy var gameProvider: GameProvider = { return GameProvider() }()
    
    private lazy var favourite: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(self.onButtonFavClicked))
        btn.tintColor = UIColor.iconFavColor
        return btn
    }()
    
    private lazy var favouriteFill: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(self.onButtonFavClicked))
        btn.tintColor = UIColor.iconFavColor
        return btn
    }()
    
    override func viewDidLayoutSubviews() {
        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.contentView.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeGame()
        isGameFavourited()
        setIconFavourite()
    }
    
    @objc private func onButtonFavClicked() {
        if isFavourite {
            guard let id = idGame else { return }
            deleteGameFromFavourite(id)
        } else {
            saveGameAsFavourite()
        }
        isFavourite = !isFavourite
        setIconFavourite()
    }
    
    private func observeGame() {
        guard let id = idGame else { return }
        self.progressBar.startAnimating()
        vm.loadGame(id: id) { (result) in
            switch result {
                case .success(let game):
                    self.viewDetail.isHidden = false
                    self.setUI(game)
                    self.hideProgressView()
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
    
    private func setUI(_ item: Game) {
        imageBanner.sd_setImage(with: item.posterUrl, placeholderImage: UIImage(named: "placeholdertext.fill"))
        imageBanner.layer.cornerRadius = 10
        textTitle.text = item.name
        textRating.text = item.ratingText + item.scoreText
        textCategory.text = item.genreText
        textReleaseDate.text = item.dateText
        textDescription.text = item.description
    }
    
    private func isGameFavourited() {
        guard let id = idGame else { return }
        gameProvider.isGameFavourited(id) { (isGameAsFavourite) in
            self.isFavourite = isGameAsFavourite
            DispatchQueue.main.async { self.setIconFavourite() }
        }
    }
    
    private func setIconFavourite() {
        if isFavourite {
            navigationItem.rightBarButtonItem = favouriteFill
        } else {
            navigationItem.rightBarButtonItem = favourite
        }
    }
    
    private func saveGameAsFavourite() {
        guard let id = idGame else { return }
        let title = textTitle.text ?? ""
        let rate = textRating.text ?? ""
        let category = textCategory.text ?? ""
        let releaseDate = textReleaseDate.text ?? ""
        let description = textDescription.text ?? ""
        let image = imageBanner.sd_imageURL?.absoluteString ?? ""
        
        gameProvider.saveGameToFavourite(id, title, rate, category, releaseDate, description, image) {
            DispatchQueue.main.async {
                self.view.makeToast("Success added to favourite")
            }
        }
    }
    
    private func deleteGameFromFavourite(_ id: Int) {
        gameProvider.deleteFavouriteGame(id) {
            DispatchQueue.main.async {
                self.view.makeToast("Success delete from favourite")
            }
        }
    }
}
