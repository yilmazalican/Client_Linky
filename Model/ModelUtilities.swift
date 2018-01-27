//
//  ErrorModel.swift
//  Linky
//
//  Created by Alican Yilmaz on 17/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import JavaScriptCore


/// Model of the error.
struct ErrorModel:Codable {
    var error:String
    
    init?(json: [String: Any]) {
        guard let error = json["error"] as? String else {
            return nil
        }
        self.error = error
        
    }
}
/// Model of occupation.
struct Occupation:Codable {
    var occupations:[String]
    init?(json:[String:Any]){
        guard let occupations = json["occupations"] as? [String] else{
            return nil
        }
        self.occupations = occupations
    }
}

///Model of token
struct TokenModel:Codable {
    var token:String
    init?(json:[String:Any]){
        guard let token = json["token"] as? String else{
            return nil
        }
        self.token = token
    }
}

