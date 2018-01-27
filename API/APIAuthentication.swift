//
//  Authentication.swift
//  Linky
//
//  Created by Alican Yilmaz on 17/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation

/// Api Endpoint for authentication requests.
class APIAuthentication:APIBASE {
    /// Use this method to log-in a user.
    /// - Parameter email: email of the user.
    /// - Parameter password: raw password of the user
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func login(email:String, password:String, completion: @escaping (_ res:String?,_ err:String?) -> ()){
        requester = RequestMaster(url: loginEndpoint, type: .POST)
        requester.POSTrequest(postString: "email=\(email)&password=\(password)", completion: {res,err in 
            guard let result = res, err == nil else{
                completion(nil,err)
                return
            }
            guard let fetchedJson = JsonFetcher.fetchJSON(data: result) else{
                completion(nil,"Error: Cannot convert response to json")
                return
            }
            guard let modeledToken = TokenModel(json:fetchedJson) else {
                completion(nil,"Error: Cannot model the responded json")
                return
            }
            completion(modeledToken.token,err)
        })
    }
    
}
