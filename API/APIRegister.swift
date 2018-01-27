//
//  APIRegister.swift
//  Linky
//
//  Created by Alican Yilmaz on 18/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation

/// Use this class to register a user.
class APIRegister: APIBASE {
    /// Use this method to register a user to the system.
    /// - Parameter email: email of the user.
    /// - Parameter name: name of the user.
    /// - Parameter surname: surname of the user.
    /// - Parameter password: password of the user.
    /// - Parameter interests: interests of the user this object must be array of String.
    /// - Parameter about: biography of the user.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func register(email:String,name:String,surname:String,password:String,interests:[String],about:String,completion: @escaping (_ res:String?,_ err:String?) -> ()){
        requester = RequestMaster(url:registerEndpoint, type: .POST)
        var index = 0
        var goingParams = ""
        for param in interests{
            goingParams += "interested[\(index)]=\(param)&"
            index+=1
        }
        goingParams.remove(at: goingParams.index(before: goingParams.endIndex))
        requester.POSTrequest(postString: "name=\(name)&surname=\(surname)&password=\(password)&email=\(email)&about=\(about)&\(goingParams)", completion: {res,err in 
            guard let _ = res, err == nil else{
                completion(nil,err)
                return
            }
            completion("OK",err)
        })
    }
    
}

