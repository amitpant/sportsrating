//
//  MatchListTableViewCell.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 28/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class MatchListTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!

    @IBOutlet weak var cellBgView: UIView!{
        didSet{
            cellBgView.layer.cornerRadius = 4.0
            /*cellBgView.layer.masksToBounds = false
            cellBgView.layer.shadowColor = UIColor.lightGray.cgColor
            cellBgView.layer.shadowOpacity = 0.2
            cellBgView.layer.shadowOffset = CGSize(width: 0, height: 1)
            cellBgView.layer.shadowRadius = 0.1
            
            cellBgView.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            cellBgView.layer.shouldRasterize = true
            cellBgView.layer.rasterizationScale = -1*/
        }
    }
    @IBOutlet weak var team1ImageView: UIImageView!{
        didSet{
            team1ImageView.layer.cornerRadius = team1ImageView.frame.size.width/2
        }
    }
    
    
    @IBOutlet weak var team1NameLabel: UILabel!
    
    @IBOutlet weak var team2ImageView: UIImageView!{
        didSet{
            team2ImageView.layer.cornerRadius = team2ImageView.frame.size.width/2
        }
    }
    
    @IBOutlet weak var team2NameLabel: UILabel!
    
    @IBOutlet weak var briefDescriptionLabel: UILabel!
    
    var event:Event?{
        didSet{
            guard let event = event else { return  }
            self.categoryLabel.text = "\(event.event_name)(\(event.cat_name))"
            self.team1NameLabel.text = event.team1_name
            self.team2NameLabel.text = event.team2_name
            
            if let imageName = event.team1_logo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imageURL = URL(string: "\(CommonHelper.imgBaseURL)\(imageName)") {
                self.team1ImageView.ap_setImage(url: imageURL)
            }
            
            if let imageName = event.team2_logo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imageURL = URL(string: "\(CommonHelper.imgBaseURL)\(imageName)") {
                self.team2ImageView.ap_setImage(url: imageURL)
            }
            
            self.briefDescriptionLabel.text = event.start_date
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
   
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        team1ImageView?.image = UIImage(named: "img-placeholder")
        team2ImageView?.image = UIImage(named: "img-placeholder")
    }
}
