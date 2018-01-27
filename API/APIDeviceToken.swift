//
//  APIDeviceToken.swift
//  Linky
//
//  Created by Alican Yilmaz on 09/12/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation

/// This class is responsible to prepare devices for remote notifications.
class APIDeviceToken: APIBASE {
    /// Use this method to register real device of current user to APNS.
    /// - Parameter token: device token that obtained from didRegisterRemoteNotifications() method.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func registerDevice(with token:String, completion: @escaping (_ res:String?,_ err:String?) -> Void){
        self.requester = RequestMaster(url: "\(getRegisterDeviceTokenEndpoint)", type: .PUT)
        requester.PUTRequest(postString: "devicetoken=\(token)") { (res, err) in
            if(err == nil){
                completion("OK", err)
            }else{
                completion(nil,err)
            }
        }
        
    }
    /// Use this method to un-register real device of current user to APNS. This method can be used when the user has been logged out.
    /// - Parameter token: device token that obtained from didRegisterRemoteNotifications() method.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func unregisterDevice(with token:String, completion: @escaping (_ res:String?,_ err:String?) -> Void){
        self.requester = RequestMaster(url: "\(getUnRegisterDeviceTokenEndpoint)", type: .DELETE)
        requester.DELETERequest(postString: "devicetoken=\(token)") { (res, err) in
            if(err == nil){
                completion("OK", err)
            }else{
                completion(nil,err)
            }
        }
        
    } 
    
}
