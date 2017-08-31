//
//  User.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 25/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation


public final class User: NSObject,NSCoding {
    //MARK - Constant
    private struct Keys{
        static let email = "email"
        static let first_name = "first_name"
        static let first_priority = "first_priority"
        static let is_player = "is_player"
        static let registration_date = "registration_date"
        static let second_priority = "second_priority"
        static let telephone = "telephone"
        static let third_priority = "third_priority"
        static let user_id = "user_id"
    }
    //MARK - Instance properties
    
    public let email : String
    public let first_name : String
    public let first_priority : String
    public let is_player : String
    public let registration_date : String
    public let second_priority : String
    public let telephone : String
    public let third_priority : String
    public let user_id : String
    //MARK - Object lifecycle
    
    public  init( email : String,
                  first_name : String,
                  first_priority : String,
                  is_player : String,
                  registration_date : String,
                  second_priority : String,
                  telephone : String,
                  third_priority : String,
                  user_id : String) {
        
        self.email = email
        self.first_name = first_name
        self.first_priority = first_priority
        self.is_player = is_player
        self.registration_date = registration_date
        self.second_priority = second_priority
        self.telephone = telephone
        self.third_priority = third_priority
        self.user_id = user_id
    }
    
    required public init?(json:[String:Any]) {
        
        guard let email = json[Keys.email] as? String,
            let first_name = json[Keys.first_name] as? String,
            let first_priority = json[Keys.first_priority] as? String,
            let is_player = json[Keys.is_player] as? String,
            let registration_date = json[Keys.registration_date] as? String,
            let second_priority = json[Keys.second_priority] as? String,
            let telephone = json[Keys.telephone] as? String,
            let third_priority = json[Keys.third_priority] as? String,
            let user_id = json[Keys.user_id] as? String
            else { return nil }
        
        self.email = email
        self.first_name = first_name
        self.first_priority = first_priority
        self.is_player = is_player
        self.registration_date = registration_date
        self.second_priority = second_priority
        self.telephone = telephone
        self.third_priority = third_priority
        self.user_id = user_id
        
    }
    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(self.email, forKey: Keys.email)
        aCoder.encode(self.first_name, forKey: Keys.first_name)
        aCoder.encode(self.first_priority, forKey: Keys.first_priority)
        aCoder.encode(self.is_player, forKey: Keys.is_player)
        aCoder.encode(self.registration_date, forKey: Keys.registration_date)
        aCoder.encode(self.second_priority, forKey: Keys.second_priority)
        aCoder.encode(self.telephone, forKey: Keys.telephone)
        aCoder.encode(self.third_priority, forKey: Keys.third_priority)
        aCoder.encode(self.user_id, forKey: Keys.user_id)
    }
    
    required convenience public init?(coder aDecoder: NSCoder){
        guard let email = aDecoder.decodeObject(forKey:Keys.email) as? String,
            let first_name = aDecoder.decodeObject(forKey:Keys.first_name) as? String,
            let first_priority = aDecoder.decodeObject(forKey:Keys.first_priority) as? String,
            let is_player = aDecoder.decodeObject(forKey:Keys.is_player) as? String,
            let registration_date = aDecoder.decodeObject(forKey:Keys.registration_date) as? String,
            let second_priority = aDecoder.decodeObject(forKey:Keys.second_priority) as? String,
            let telephone = aDecoder.decodeObject(forKey:Keys.telephone) as? String,
            let third_priority = aDecoder.decodeObject(forKey:Keys.third_priority) as? String,
            let user_id = aDecoder.decodeObject(forKey:Keys.user_id) as? String
            else { return nil }
        
        self.init(email: email, first_name: first_name, first_priority: first_priority, is_player: is_player, registration_date: registration_date, second_priority: second_priority, telephone: telephone, third_priority: third_priority, user_id: user_id)
    }
    
}
