//
//  TeamPlayersDetailTVC.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 29/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class TeamPlayersDetailTVC: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var teamSegment: UISegmentedControl!
    
    var event:Event?
    var players:[Player] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let width =  collectionView.frame.width/2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width - 10 , height: 60  )
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        
    }
    
    @IBAction func teamValueChanged(_ sender: UISegmentedControl) {
         guard let event = event else { return  }
        if sender.selectedSegmentIndex == 0{
            players = event.Team1!
        }else{
            players = event.Team2!
        }
        collectionView.reloadData()
    }
    

}
extension TeamPlayersDetailTVC:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let playerCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayersInfoCVC", for: indexPath) as? PlayersInfoCVC else { return UICollectionViewCell() }
        playerCVC.player = players[indexPath.item]
        return playerCVC
    }
    
    
}
