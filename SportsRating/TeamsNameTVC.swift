//
//  TeamsNameTVC.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 29/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

protocol TeamsNameTVCDelegate:class {
    func selTeamChanged(index:Int)
}
class TeamsNameTVC: UITableViewCell {

    weak var delegate:TeamsNameTVCDelegate?
    @IBOutlet weak var team1Button: UIButton!
    @IBOutlet weak var team2Button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func team1BtnPressed(_ sender: UIButton) {
       
        team1Button.setTitleColor(.white, for: .normal)
        team2Button.setTitleColor(.black, for: .normal)
        delegate?.selTeamChanged(index: sender.tag)
    }
    @IBAction func team2BtnPressed(_ sender: UIButton) {
        team1Button.setTitleColor(.black, for: .normal)
        team2Button.setTitleColor(.white, for: .normal)
        delegate?.selTeamChanged(index: sender.tag)
    }
}
