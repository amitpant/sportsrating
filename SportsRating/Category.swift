//
//  Category.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 22/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation
/*
 {
 "category_id": "9",
 "name": "Rugby",
 "banner": "1502885640download (10).jpg",
 "link": "",
 "date": "2017-08-16",
 "bind_menu": "",
 "date_time_create": "0000-00-00 00:00:00",
 "last_modify": "2017-08-16 17:27:38",
 "position": "0",
 "status": "0",
 "content": ""
 }
 */

public final class Category: NSObject,NSCoding{
    //MARK - Constants
    private struct Keys{
        static let category_id = "category_id"
        static let name = "name"
        static let banner = "banner"
        static let link = "link"
        static let date = "date"
        static let bind_menu = "bind_menu"
        static let date_time_create = "date_time_create"
        static let last_modify = "last_modify"
        static let position = "position"
        static let status = "status"
        static let content = "content"
    }
    
    //MARK - Instance Properties
    public let category_id : String
    public let name : String
    public let banner : String
    public let link : String
    public let date : String
    public let bind_menu : String
    public let date_time_create : String
    public let last_modify : String
    public let position : String
    public let status : String
    public let content : String
    
    //MARK - Object lifecycle
    public init(  category_id : String,
                  name : String,
                  banner : String,
                  link : String,
                  date : String,
                  bind_menu : String,
                  date_time_create : String,
                  last_modify : String,
                  position : String,
                  status : String,
                  content : String) {
        self.category_id = category_id
        self.name = name
        self.banner = banner
        self.link = link
        self.date = date
        self.bind_menu = bind_menu
        self.date_time_create = date_time_create
        self.last_modify = last_modify
        self.position = position
        self.status = status
        self.content = content
    }
    
    required public init?(json:[String:Any]) {
        guard let category_id = json[Keys.category_id] as? String,
            let name = json[Keys.name] as? String,
            let banner = json[Keys.banner] as? String,
            let link = json[Keys.link] as? String,
            let date = json[Keys.date] as? String,
            let bind_menu = json[Keys.bind_menu] as? String,
            let date_time_create = json[Keys.date_time_create] as? String,
            let last_modify = json[Keys.last_modify] as? String,
            let position = json[Keys.position] as? String,
            let status = json[Keys.status] as? String,
            let content = json[Keys.content] as? String
            else { return nil }
        
        self.category_id = category_id
        self.name = name
        self.banner = banner
        self.link = link
        self.date = date
        self.bind_menu = bind_menu
        self.date_time_create = date_time_create
        self.last_modify = last_modify
        self.position = position
        self.status = status
        self.content = content
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        
        guard let category_id = aDecoder.decodeObject(forKey: Keys.category_id) as? String,
            let name = aDecoder.decodeObject(forKey: Keys.name) as? String,
            let banner = aDecoder.decodeObject(forKey: Keys.banner) as? String,
            let link = aDecoder.decodeObject(forKey: Keys.link) as? String,
            let date = aDecoder.decodeObject(forKey: Keys.date) as? String,
            let bind_menu = aDecoder.decodeObject(forKey: Keys.bind_menu) as? String,
            let date_time_create = aDecoder.decodeObject(forKey: Keys.date_time_create) as? String,
            let last_modify = aDecoder.decodeObject(forKey: Keys.last_modify) as? String,
            let position = aDecoder.decodeObject(forKey: Keys.position) as? String,
            let status = aDecoder.decodeObject(forKey: Keys.status) as? String,
            let content = aDecoder.decodeObject(forKey: Keys.content) as? String
            else { return nil }
        
        self.init(category_id: category_id, name: name, banner: banner, link: link, date: date, bind_menu: bind_menu, date_time_create: date_time_create, last_modify: last_modify, position: position, status: status, content: content)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.category_id, forKey: Keys.category_id)
        aCoder.encode(self.name, forKey: Keys.name)
        aCoder.encode(self.banner, forKey: Keys.banner)
        aCoder.encode(self.link, forKey: Keys.link)
        aCoder.encode(self.date, forKey: Keys.date)
        aCoder.encode(self.bind_menu, forKey: Keys.bind_menu)
        aCoder.encode(self.date_time_create, forKey: Keys.date_time_create)
        aCoder.encode(self.last_modify, forKey: Keys.last_modify)
        aCoder.encode(self.position, forKey: Keys.position)
        aCoder.encode(self.status, forKey: Keys.status)
        aCoder.encode(self.content, forKey: Keys.content)
    }
    //MARK - Class Constructors
    
    class func array(jsonObject:[[String:Any]]) -> [Category]{
        var arrayCategory:[Category] = []
        
        for json in jsonObject {
            guard let category = Category(json:json) else { continue }
            arrayCategory.append(category)
        }
        return arrayCategory
    }
}
