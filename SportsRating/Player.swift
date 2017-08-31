//
//  Player.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 28/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation

//MARK:- Constants
private enum Keys {
    static let id = "id"
    static let match_id = "match_id"
    static let player_name = "player_name"
    static let is_individual = "is_individual"
    static let team_number = "team_number"
    static let rating = "rating"
    
}

public final class Player{
    
    //MARK - Instance properties
    public let id : String
    public let match_id : String
    public let player_name : String
    public let is_individual : String
    public let team_number : String
    var rating : Int?
    //MARK - Object LifeCycle
    public init( id : String,
                 match_id : String,
                 player_name : String,
                 is_individual : String,
                 team_number : String,
                 rating: Int?){
        self.id = id
        self.match_id = match_id
        self.player_name = player_name
        self.is_individual = is_individual
        self.team_number = team_number
        self.rating = rating
    }
    
    required public init?(json:[String:Any]) {
        guard let id = json[Keys.id] as? String,
        let match_id = json[Keys.match_id] as? String,
        let player_name = json[Keys.player_name] as? String,
        let is_individual = json[Keys.is_individual] as? String,
        let team_number = json[Keys.team_number] as? String
            else { return nil }
        self.id = id
        self.match_id = match_id
        self.player_name = player_name
        self.is_individual = is_individual
        self.team_number = team_number
        if let rating = json[Keys.rating] as? String  {
            if rating.characters.count>0 {
                self.rating = Int(rating)
            }else{
                self.rating = 0
            }
            
        }
    }
   
    //MARK - Class Constructors
    class func array(josnObject:[[String:Any]])->[Player]{
        var arrPlayers:[Player] = []
        for json in josnObject{
            guard let player = Player(json: json) else { continue }
            arrPlayers.append(player)
        }
        return arrPlayers
    }
}
