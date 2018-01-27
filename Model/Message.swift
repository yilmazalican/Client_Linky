//
//  Message.swift
//  Linky
//
//  Created by Alican Yilmaz on 17/12/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
/// This is model for Message object that used on chat.
struct Message : Decodable {
    var author: String?
    var message: String?
    var _id: String?
    var createdAt: String?
    var name:String?
    
    func getDateOfMe() -> Date! {
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFor.date(from: self.createdAt!)
    }

}

struct Conversation: Decodable {
    var p1:String?
    var p2:String?
    var messages:[Message]?
}

/// This is model for notifications that is used on socket.io server.
struct NotifMessage : Decodable {
    var sender: String?
    var msg:String?
    
}
