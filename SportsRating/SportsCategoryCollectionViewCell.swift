//
//  SportsCategoryCollectionViewCell.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 24/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class SportsCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sportsCategoryNameLabel: UILabel!
    @IBOutlet weak var sportsCategoryImageView: UIImageView!{
        didSet{
            sportsCategoryImageView.layer.cornerRadius = 4.0
            sportsCategoryImageView.clipsToBounds = true
            sportsCategoryImageView.contentMode = .scaleAspectFill
        }
    }
    var category:Category?{
        didSet{
            guard let category = category else { return  }
            self.sportsCategoryNameLabel.text = category.name
            if let imageName = category.banner.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imageURL = URL(string: "\(CommonHelper.imgBaseURL)\(imageName)") {
                self.sportsCategoryImageView.ap_setImage(url: imageURL)
            }
            
        }
    }
}
