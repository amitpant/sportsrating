//
//  EventDetailViewController.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 29/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    var eventType:String?
    var matchID:String?
    
    var event:Event?
    
    var selTeamTabIndex = 1
    var team1PlayerRating:[String:String] = [:]
    //var team2PlayerRating:[String:String] = [:]
    
    var isEditingMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        if let evnttype = eventType, !evnttype.hasPrefix("upcoming") {
            
            loadEventDetails()
        }
        else{
            ratingButton.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func rateBtnPressed(_ sender: Any) {
        
        if isEditingMode {
            var arrPlayersRating:[[String:String]] = []
            for (key,value) in team1PlayerRating {
               // print("\(key) = \(value)")
                let playerRating = ["id":key,"rate":value ] as [String:String]
                arrPlayersRating.append(playerRating)
            }
            postRating(playersRating: arrPlayersRating)
        }
        else{
            
            ratingButton.setTitle("SUBMIT RATING", for:.normal)
            isEditingMode = true
            self.tableView.reloadData()
        }
       
    }
    
    func loadEventDetails() {
        guard let eventType = eventType else { return  }
        guard let matchID = matchID else { return  }
        guard let userObject = UserDefaults.standard.data(forKey: "userObject"), let user = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data ) as? User
            else { return  }
        var params = ["action":"\(eventType)Details","user_id":"\(user.user_id)","Match_id":"\(matchID)"] as [String:Any]
        if  eventType.hasPrefix("finished") {
            params = ["action":"\(eventType)Details","user_id":"\(user.user_id)","match_id":"\(matchID)"] as [String:Any]
        }
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        NetworkClient.shared.callAPI(params: params, success: { [weak self](response) in
            print(response)
            guard let strongSelf = self else{return}
            if let status = response["status"] as? Bool, status{
                if let data = response["data"] as? [String:Any] {
                    strongSelf.event = Event(json: data)
                }
                else if let data = response["data"] as? [[String:Any]]{
                    strongSelf.event = Event.Array(jsonObject:data)[0]
                }
                DispatchQueue.main.async {
                    strongSelf.loadPlayerRating()
                    strongSelf.messageLabel.isHidden = true
                    strongSelf.tableView.isHidden = false
                    strongSelf.tableView.reloadData()
                    strongSelf.ratingButton.isHidden = false
                }
            }
            else if let message = response["message"] as? String{
                DispatchQueue.main.async {
                    strongSelf.messageLabel.isHidden = false
                    strongSelf.messageLabel.text = message
                    strongSelf.tableView.isHidden = true
                    strongSelf.ratingButton.isHidden = true
                }
                
                //CommonHelper.showAlertMessage(vc: strongSelf, title: "Server Error!!!", message: message)
            }
            CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
            })
        { (error) in
            CommonHelper.showAlertMessage(vc: self, title: "Network Error!!!", message: error.localizedDescription)
            CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
        }
    }
    
    
    func postRating(playersRating:[[String:String]]) {
        //guard let dicPlayerRating = dicPlayerRating else { return  }
        guard let matchID = matchID else { return  }
        guard let userObject = UserDefaults.standard.data(forKey: "userObject"), let user = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data ) as? User
            else { return  }
        
        
        let params = ["action":"Rating","user_id":"\(user.user_id)","match_id":"\(matchID)","rating":playersRating] as [String:Any]
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        NetworkClient.shared.callAPI(params: params, success: { [weak self](response) in
            print(response)
            guard let strongSelf = self else{return}
            if let status = response["status"] as? Bool, status{
                DispatchQueue.main.async {
                    strongSelf.ratingButton.setTitle("RATE PLAYERS", for:.normal)
                    strongSelf.isEditingMode = false
                    strongSelf.tableView.reloadData()
                }
            }
            else if let message = response["message"] as? String{
                CommonHelper.showAlertMessage(vc: strongSelf, title: "Server Error!!!", message: message)
            }
            CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
            })
        { (error) in
            CommonHelper.showAlertMessage(vc: self, title: "Network Error!!!", message: error.localizedDescription)
            CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
        }
    }
    
    func loadPlayerRating() {
        if let event = event, let team1 = event.Team1, let team2 = event.Team2 {
            for player in team1 {
                if let rating = player.rating, rating > 0 {
                    team1PlayerRating["\(player.id)"] = "\(rating)"
                }
            }
            for player in team2 {
                if let rating = player.rating , rating > 0 {
                    team1PlayerRating["\(player.id)"] = "\(rating)"
                }
            }
        }
    }
}

extension EventDetailViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let event = event, let team = event.Team1 {
            var playerRows = 0
            if team.count % 2 == 0 {
                playerRows = team.count/2
            }
            else{
                playerRows = team.count/2 + 1
            }
            return (playerRows + 3)
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath.row)
        let celltype = indexPath.row > 2 ? 3 : indexPath.row
        switch celltype{
        case 0:
            print("header cell")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchListTableViewCell", for: indexPath) as? MatchListTableViewCell else { return UITableViewCell() }
            cell.event = event
            return cell
        case 1:
            print("description")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchDescriptionTVC", for: indexPath) as? MatchDescriptionTVC else { return UITableViewCell() }
            cell.descriptionLabel.text = event?.description
            return cell
        case 2:
            print("Players info")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamsNameTVC", for: indexPath) as? TeamsNameTVC else { return UITableViewCell() }
            cell.delegate = self
            if let event = event {
                cell.team1Button.setTitle(event.team1_name.uppercased(), for: .normal)
                cell.team2Button.setTitle(event.team2_name.uppercased(), for: .normal)
            }
            return cell
        case 3:
            print("Players info")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerDetailsTVC", for: indexPath) as? PlayerDetailsTVC else { return UITableViewCell() }
            
            cell.isEditingMode = isEditingMode
            cell.player1RatingControl.delegate = self
            cell.player2RatingControl.delegate = self
            
            
            
            
            if let event = event {
                var team = event.Team1
                cell.teamPlayerRating = self.team1PlayerRating
                if selTeamTabIndex == 2 {
                    team = event.Team2
                    //cell.teamPlayerRating = self.team2PlayerRating
                }
                var playerIndex = (indexPath.row - 3) + (indexPath.row - 3)
                if (team?.count)! > playerIndex {
                    cell.player1 = team![playerIndex]
                    playerIndex += 1
                    if (team?.count)! > playerIndex {
                        cell.player2 =  team![playerIndex]
                    }
                }
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let celltype = indexPath.row > 2 ? 3 : indexPath.row
        switch celltype {
        case 0:
            print("header cell")
            
            return 160
        case 1:
            print("description")
            
            return 60
        case 2:
            print("Players info")
            
            return 44
        case 3:
            print("Players info")
           
            if let eventType = eventType, eventType.hasPrefix("upcoming") {
                return 40
            }
            else{
                return 70
            }
            
        default:
            return 44
        }
    }
}
extension EventDetailViewController:TeamsNameTVCDelegate{
    func selTeamChanged(index: Int) {
        self.selTeamTabIndex = index
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        /*var indexPaths:IndexPath = []
        if let event = event, let team = event.Team1 {
            var playerRows = 0
            if team.count % 2 == 0 {
                playerRows = team.count/2
            }
            else{
                playerRows = team.count/2 + 1
            }
            for row in 3..<(playerRows + 3) {
                print(row)
                indexPaths.append(IndexPath(row: row, section: 0))
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPaths], with: .automatic)
        }*/
        
    }
}

extension EventDetailViewController:RatingControlDelegate{
    func playingRatingButtonTapped(ctrl:RatingControl,playerid: Int, rating: Int) {
        
        
        
            if team1PlayerRating.count < 4  {
                team1PlayerRating["\(playerid)"] = "\(rating)"
                if team1PlayerRating.count == 4  {
                    UserDefaults.standard.set(true, forKey: "isStopRatingPlayers")
                }
            }
            else if team1PlayerRating["\(playerid)"] != nil{
                if ctrl.rating == 0  {
                    team1PlayerRating.removeValue(forKey: "\(playerid)")
                    UserDefaults.standard.set(false, forKey: "isStopRatingPlayers")
                }
                else{
                    team1PlayerRating["\(playerid)"] = "\(rating)"
                    ctrl.rating = rating
                }
                
            }
            else if ctrl.rating > 0 && team1PlayerRating.count == 4 {
                CommonHelper.showAlertMessage(vc: self, title: "Alert", message: "You can rate maximum 4 players.")
                ctrl.rating = 0
            }
        
        /*else{
            if team2PlayerRating.count < (4 - team2PlayerRating.count) {
                team2PlayerRating["\(playerid)"] = "\(rating)"
                if team2PlayerRating.count == (4 - team2PlayerRating.count) {
                    UserDefaults.standard.set(true, forKey: "isStopRatingPlayers")
                }
            }
            else if team2PlayerRating["\(playerid)"] != nil{
                if ctrl.rating == 0  {
                    team2PlayerRating.removeValue(forKey: "\(playerid)")
                    UserDefaults.standard.set(false, forKey: "isStopRatingPlayers")
                }
                else{
                    team2PlayerRating["\(playerid)"] = "\(rating)"
                    ctrl.rating = rating
                }
                
            }
            else if ctrl.rating > 0 && team2PlayerRating.count == (4 - team2PlayerRating.count){
                CommonHelper.showAlertMessage(vc: self, title: "Alert", message: "You can rate maximum 4 players.")
                ctrl.rating = 0
            }
        }
        */
       /* if dicPlayerRating.count < 4 {
            dicPlayerRating["\(playerid)"] = "\(rating)"
            if dicPlayerRating.count == 4 {
                UserDefaults.standard.set(true, forKey: "isStopRatingPlayers")
            }
        }
        else if dicPlayerRating["\(playerid)"] != nil{
            if ctrl.rating == 0  {
                dicPlayerRating.removeValue(forKey: "\(playerid)")
                UserDefaults.standard.set(false, forKey: "isStopRatingPlayers")
            }
            else{
                dicPlayerRating["\(playerid)"] = "\(rating)"
                ctrl.rating = rating
            }
            
        }
        else if ctrl.rating > 0 && dicPlayerRating.count == 4{
            CommonHelper.showAlertMessage(vc: self, title: "Alert", message: "You can rate maximum 4 players.")
            ctrl.rating = 0
        }
       */
        
    }
}
