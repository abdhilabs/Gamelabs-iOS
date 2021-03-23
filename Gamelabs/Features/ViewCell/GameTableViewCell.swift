//
//  GameTableViewCell.swift
//  Gamelabs
//
//  Created by Abdhi on 04/03/21.
//

import UIKit
import SDWebImage

class GameTableViewCell: UITableViewCell {
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var nameGame: UILabel!
    @IBOutlet weak var releaseDateGame: UILabel!
    @IBOutlet weak var ratingGame: UILabel!
    
    func setCellWithValuesOf(_ game: Game) {
        setupUI(game.name, game.posterUrl, game.dateText, game.ratingText + game.scoreText)
    }
    
    func setCellWithValuesOf(_ game: FavouriteModel) {
        setupUI(game.name, URL(string: game.backgroundImage ?? ""), game.released, game.ratingAverage)
    }
    
    private func setupUI(_ title: String?, _ poster: URL?, _ releaseDate: String?, _ rating: String?) {
        self.imageGame.sd_setImage(with: poster, placeholderImage: UIImage(named: "placeholdertext.fill"))
        self.imageGame.layer.cornerRadius = 10
        self.nameGame.text = title
        self.releaseDateGame.text = releaseDate
        self.ratingGame.text = rating
    }
}
