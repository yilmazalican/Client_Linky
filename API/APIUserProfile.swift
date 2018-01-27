//
//  APIUserProfile.swift
//  Linky
//
//  Created by Alican Yilmaz on 29/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
/// API endpoint for profile information of a user.
class APIUserProfile:APIBASE {
    /// Use this method to get current profile information of current user.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    public func getProfileOfCurrent(completion: @escaping (_ res:User?, _ err:String?) -> Void){
        self.requester = RequestMaster(url: "\(getUserProfileEndpoint)", type: .GET)
        requester.GETRequest { (data, err) in
            if(err == nil){
                let fetchedJson = JsonFetcher.fetchJSON(data: data!)
                let user = User(json: fetchedJson!)
                completion(user,nil)
            }else{
                completion(nil,err)
            }
        }
    }
    /// Use this method to get current profile image of a user.
    /// - Parameter id: The id of user that will be used.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    public func getProfile(id:String,completion: @escaping (_ res:User?, _ err:String?) -> Void){
        self.requester = RequestMaster(url: "\(getUserProfileEndpoint)/\(id)", type: .GET)
        requester.GETRequest { (data, err) in
            if(err == nil){
                let fetchedJson = JsonFetcher.fetchJSON(data: data!)
                let user = User(json: fetchedJson!)
                completion(user,nil)
            }else{
                completion(nil,err)
            }
        }
    }
}
