//
//  Event.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 28/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation

//MARK: - Constants
private enum Keys{
    static let event_id = "event_id"
    static let event_name = "event_name"
    static let image = "image"
    static let m_image = "m_image"
    static let l_image = "l_image"
    static let description = "description"
    static let category = "category"
    static let mode = "mode"
    static let start_date = "start_date"
    static let duration = "duration"
    static let team_number = "team_number"
    static let players_number = "players_number"
    static let team1_logo = "team1_logo"
    static let team2_logo = "team2_logo"
    static let team1_name = "team1_name"
    static let team2_name = "team2_name"
    static let is_live = "is_live"
    static let cat_name = "cat_name"
    static let Team1 = "Team1"
    static let Team2 = "Team2"
}

public enum ModeType {
    case Team
    case Individual
}

public final class Event{
    //MARK: - Instance properties
    public let event_id : String
    public let event_name : String
    public let image : String
    public let m_image : String
    public let l_image : String
    public let description : String
    public let category : String
    public var mode : ModeType
    public let start_date : String
    public let duration : String
    public let team_number : String
    public let players_number : String
    public let team1_logo : String
    public let team2_logo : String
    public let team1_name : String
    public let team2_name : String
    public let is_live : Bool
    public let cat_name : String
    public var Team1 : [Player]?
    public var Team2 : [Player]?
    
    //MARK: - Object lifecycle
    public init( event_id : String,
                 event_name : String,
                 image : String,
                 m_image : String,
                 l_image : String,
                 description : String,
                 category : String,
                 mode : ModeType,
                 start_date : String,
                 duration : String,
                 team_number : String,
                 players_number : String,
                 team1_logo : String,
                 team2_logo : String,
                 team1_name : String,
                 team2_name : String,
                 is_live : Bool,
                 cat_name : String,
                 Team1 : [Player]?,
                 Team2 : [Player]?)
    {
        self.event_id =  event_id
        self.event_name =  event_name
        self.image =  image
        self.m_image =  m_image
        self.l_image =  l_image
        self.description =  description
        self.category =  category
        self.mode =  mode
        self.start_date =  start_date
        self.duration =  duration
        self.team_number =  team_number
        self.players_number =  players_number
        self.team1_logo =  team1_logo
        self.team2_logo =  team2_logo
        self.team1_name =  team1_name
        self.team2_name =  team2_name 
        self.is_live =  is_live 
        self.cat_name =  cat_name 
        self.Team1 =  Team1 
        self.Team2 =  Team2 
    }
    
    required public init?( json:[String: Any])
    {
        guard let event_id = json[Keys.event_id] as? String,
        let event_name = json[Keys.event_name] as? String,
        let image = json[Keys.image] as? String,
        let m_image = json[Keys.m_image] as? String,
        let l_image = json[Keys.l_image] as? String,
        let description = json[Keys.description] as? String,
        let category = json[Keys.category] as? String,
        let mode = json[Keys.mode] as? String,
        let start_date = json[Keys.start_date] as? String,
        let duration = json[Keys.duration] as? String,
        let team_number = json[Keys.team_number] as? String,
        let players_number = json[Keys.players_number] as? String,
        let team1_logo = json[Keys.team1_logo] as? String,
        let team2_logo = json[Keys.team2_logo] as? String,
        let team1_name = json[Keys.team1_name] as? String,
        let team2_name = json[Keys.team2_name] as? String,
        let is_live = json[Keys.is_live] as? Bool,
        let cat_name = json[Keys.cat_name] as? String
       
        else { return nil }
        
        self.event_id =  event_id
        self.event_name =  event_name
        self.image =  image
        self.m_image =  m_image
        self.l_image =  l_image
        self.description =  description
        self.category =  category
        self.mode = (mode == "Team") ? .Team : .Individual
        self.start_date =  start_date
        self.duration =  duration
        self.team_number =  team_number
        self.players_number =  players_number
        self.team1_logo =  team1_logo
        self.team2_logo =  team2_logo
        self.team1_name =  team1_name
        self.team2_name =  team2_name
        self.is_live =  is_live
        self.cat_name =  cat_name
        
        if let playerlist = json[Keys.Team1] as? [[String:Any]] {
            self.Team1 = Player.array(josnObject: playerlist)
        }
        if let playerlist = json[Keys.Team2] as? [[String:Any]] {
            self.Team2 = Player.array(josnObject: playerlist)
        }
    }
    
    //MARK: - Class Constructor
    class func Array(jsonObject:[[String:Any]]) -> [Event] {
        var arrEvent:[Event] = []
        for json in jsonObject {
            guard let event = Event(json: json) else { continue }
            arrEvent.append(event)
        }
        return arrEvent
        
    }
}
