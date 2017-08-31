//
//  PlayerDetailsTVC.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 29/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class PlayerDetailsTVC: UITableViewCell {
    
    @IBOutlet weak var player1NameLabel: UILabel!
    @IBOutlet weak var player1RatingControl: RatingControl!
    @IBOutlet weak var player2NameLabel: UILabel!
    @IBOutlet weak var player2RatingControl: RatingControl!
    @IBOutlet weak var player1BgView: UIView!{
        didSet{
            player1BgView.layer.cornerRadius = 3.0
        }
    }
    
    @IBOutlet weak var player2BgView: UIView!{
        didSet{
            player2BgView.layer.cornerRadius = 3.0
        }
    }
    
    var teamPlayerRating:[String:String] = [:]
    
    var player1:Player?{
        didSet{
            guard let player = player1 else { return  }
            self.player1NameLabel.text = player.player_name
            self.player1NameLabel.isHidden = false
            self.player1BgView.isHidden = false
            if let rating = player.rating {
                if teamPlayerRating.count > 0{
                    if teamPlayerRating["\(player.id)"] != nil {
                        if let rated  = teamPlayerRating["\(player.id)"], let intRated = Int(rated){
                            self.player1RatingControl.rating = intRated
                        }
                    }
                    else{
                        self.player1RatingControl.rating = 0
                    }
                }
                else{
                    self.player1RatingControl.rating = rating
                }
                if let playerid = Int(player.id){
                    self.player1RatingControl.tag = playerid
                }
                self.player1RatingControl.isHidden = false
                self.player1RatingControl.isUserInteractionEnabled = isEditingMode
            }
        }
    }
    
    var player2:Player?{
        didSet{
            guard let player = player2 else { return  }
            self.player2NameLabel.text = player.player_name
            self.player2NameLabel.isHidden = false
            self.player2BgView.isHidden = false
            if let rating = player.rating {
                if teamPlayerRating.count > 0{
                    if teamPlayerRating["\(player.id)"] != nil {
                        if let rated  = teamPlayerRating["\(player.id)"], let intRated = Int(rated){
                            self.player2RatingControl.rating  = intRated
                        }
                    }else{
                        self.player2RatingControl.rating  = 0
                    }
                }
                else{
                    self.player2RatingControl.rating = rating
                }
                
                self.player2RatingControl.isHidden = false
                player2RatingControl.isUserInteractionEnabled = isEditingMode
                if let playerid = Int(player.id){
                    self.player2RatingControl.tag = playerid
                }
            }
        }
    }
    
    var isEditingMode:Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

