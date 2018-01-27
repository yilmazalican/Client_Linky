//
//  APIProfileImage.swift
//  Linky
//
//  Created by Alican Yilmaz on 23/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
/// API endpoint of the profile image of a user.
class APIProfileImage:APIBASE {
    /// Use this method to get current profile image of a user.
    /// - Parameter user: The id of user that will be used.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func getProfileImage(of user:String,completion: @escaping (_ res:Data?, _ err:String?) -> Void){
        self.requester = RequestMaster(url: "\(getProfilePictureEndpoint)/\(user)", type: .GET)
        requester.GETRequest { (data, err) in
            completion(data,err)
        }
    }
    /// Use this method to update profile picture of current user.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - Parameter imgdata: image data that will substituded with current profile image.
    /// - returns: Void
    func uploadProfilePicture(imgdata:Data, completion: @escaping (_ res:Data?, _ err:String?) -> Void){
        self.requester = RequestMaster(url: uploadProfilePictureEndpoint, type: .MultipartPOST)
        requester.multipartPOSTRequest(data: imgdata, contentType: "image/jpeg", fileName: "picture.jpg", name: "profile") { (res, err) in
            completion(res,err)
        }
    }
}
