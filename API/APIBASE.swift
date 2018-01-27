//
//  APIBASE.swift
//  Linky
//
//  Created by Alican Yilmaz on 18/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
/// This class is set for only setting the endpoint urls
class APIBASE {
    var requester:RequestMaster!
    let ip = "http://104.45.22.103:4000"
    let loginEndpoint:String
    let occupationEndpoint:String
    let registerEndpoint:String
    let createCheckinEndpoint:String
    let getCurrentCheckinEndpoint:String
    let editCurrentCheckinEndpoint:String
    let getMatchesEndpoint:String
    let getProfilePictureEndpoint:String
    let uploadProfilePictureEndpoint:String
    let getUserProfileEndpoint:String
    let editProfileEndpoint:String
    let getRegisterDeviceTokenEndpoint:String
    let getUnRegisterDeviceTokenEndpoint:String

    required init() {
        loginEndpoint = "\(ip)/login"
        occupationEndpoint = "\(ip)/occupations"
        registerEndpoint = "\(ip)/register"
        createCheckinEndpoint = "\(ip)/checkin/create"
        getCurrentCheckinEndpoint = "\(ip)/checkin/current"
        editCurrentCheckinEndpoint = "\(ip)/checkin/edit"
        getMatchesEndpoint = "\(ip)/match"
        getProfilePictureEndpoint = "\(ip)/profileimage"
        uploadProfilePictureEndpoint = "\(ip)/profileimage"
        getUserProfileEndpoint = "\(ip)/userProfile"
        editProfileEndpoint = "\(ip)/editprofile"
        getRegisterDeviceTokenEndpoint = "\(ip)/registerdevice"
        getUnRegisterDeviceTokenEndpoint = "\(ip)/unregisterdevice"
    }
}
