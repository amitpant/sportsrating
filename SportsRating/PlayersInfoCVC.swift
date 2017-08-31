//
//  PlayersInfoCVC.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 29/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class PlayersInfoCVC: UICollectionViewCell {
    @IBOutlet weak var playerRating: RatingControl!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    var player:Player?{
        didSet{
            guard let player = player else { return  }
            self.playerNameLabel.text  = player.player_name
            self.playerRating.rating = 3
        }
    }
    
}
