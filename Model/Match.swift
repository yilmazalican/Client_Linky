//
//  Match.swift
//  Linky
//
//  Created by Alican Yilmaz on 23/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import JavaScriptCore
/// This is model for match.
struct Match {
    var checkin:Checkin
    var user:User
    var createdAt:Date
    init?(json:[String:Any]){
        guard let checkin = json["checkin"] as? [String:Any] else{
            return nil
        }
        guard let user = json["user"] as? [String:Any] else{
            return nil
        }
        guard let createdAt = json["createdAt"] as? String else{
            return nil
        }
        
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let myDate: Date? = dateFor.date(from: createdAt)
        self.createdAt = myDate!
        self.user = User(json:user)!
        self.checkin = Checkin(json:checkin)!
    }
}
