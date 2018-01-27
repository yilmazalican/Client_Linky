//
//  User.swift
//  Linky
//
//  Created by Alican Yilmaz on 23/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import JavaScriptCore
/// This is model for User object.
struct User {
    var id:String
    var about:String
    var createdAt:Date
    var interested:[String]
    var email:String
    var surname:String
    var name:String
    init?(json:[String:Any]){
        guard let id = json["_id"] as? String else{
            return nil
        }
        guard let about = json["about"] as? String else{
            return nil
        }
        guard let createdAt = json["createdAt"] as? String else{
            return nil
        }
        guard let interested = json["interested"] as? [String] else{
            return nil
        }
        guard let email = json["email"] as? String else{
            return nil
        }
        guard let surname = json["surname"] as? String else{
            return nil
        }
        guard let name = json["name"] as? String else{
            return nil
        }
        self.id = id
        self.about = about
        self.interested = interested
        self.email = email
        self.surname = surname
        self.name = name

        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let myDate: Date? = dateFor.date(from: createdAt)
        self.createdAt = myDate!
    }
    
}
