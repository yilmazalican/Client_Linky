//
//  APIEditProfile.swift
//  Linky
//
//  Created by Alican Yilmaz on 29/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
/// API endpoint for edditing profile of users
class APIEditProfile:APIBASE {
    /// Use this method to edit current profile information of current user.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    public func editProfile(name:String,surname:String,about:String,occupations:[String],completion: @escaping (_ completion:Bool?, _ err:String?) -> Void){
        self.requester = RequestMaster(url: "\(editProfileEndpoint)", type: .PUT)
        var index = 0
        var goingParams = ""
        for param in occupations{
            goingParams += "interested[\(index)]=\(param)&"
            index+=1
        }
        goingParams.remove(at: goingParams.index(before: goingParams.endIndex))
        requester.PUTRequest(postString: "name=\(name)&surname=\(surname)&about=\(about)&\(goingParams)") { (data, err) in
            if(err != nil){
                completion(nil,err)
            }else{
                completion(true,nil)
            }
        }
    }
}
