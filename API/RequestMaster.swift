//
//  HTTPRequester.swift
//  Linky
//
//  Created by Alican Yilmaz on 17/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import JavaScriptCore
import UIKit
import NotificationBannerSwift

enum RequestType{
    case GET
    case POST
    case PUT
    case DELETE
    case MultipartPOST
}

/// RequestMaster is responsible to prepare the sessioned url requests.
class RequestMaster {
    var boundary:String!
    var request:URLRequest!
    var authHeader:String?
    
    init(url:String, type:RequestType) {
        self.boundary = NSUUID().uuidString
        initializeRequest(url:url,type: type)
    }
    
    init(){}
    /// Does multipart-formdata request. Its suitable to use this method when uploading images to the server.
    /// - Parameter data: The data of the request. This may be an image.
    /// - Parameter contentType: Content-type of request, this will add into header fields of HTTP request.
    /// - Parameter fileName: name of the form field.
    /// - Parameter name: name of the request field.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func multipartPOSTRequest(data:Data, contentType:String, fileName:String,name:String, completion: @escaping((_ res:Data?,_ err:String?) -> Void)){
        if let authHeader = self.authHeader {
            request.addValue("Bearer \(authHeader)", forHTTPHeaderField:"Authorization" )
        }
        request.addValue("no-cache", forHTTPHeaderField: "cache-control")
        
        var body = Data()
        body.append(string:"--\(boundary!)\r\n")
        body.append(string:"Content-Disposition:form-data; name=\"\(name)\"; fileName=\"\(fileName)\"\r\n")
        body.append(string: "Content-Type: \(contentType)\r\n\r\n")
        body.append(data)
        body.append(string: "\r\n")
        body.append(string:"--\(boundary!)--\r\n")
        
        request.httpBody = body
        requestSession(request: self.request) { (res, err) in
            completion(res,err)
        }
    }
    /// Does Post request. Its suitable to use this method when sending data to the server.
    /// - Parameter postString: The HTTP post string that will evaulate on the serverside.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func POSTrequest(postString:String,  completion: @escaping((_ res:Data?,_ err:String?) -> Void)){
        if let authHeader = self.authHeader {
            request.addValue("Bearer \(authHeader)", forHTTPHeaderField:"Authorization" )
        }
        request.httpBody = postString.data(using: .utf8)
        requestSession(request: self.request) { (res, err) in
            completion(res,err)
        }
        
    }
    /// Does Post request. Its suitable to use this method when receive data from the server.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func GETRequest(completion: @escaping((_ res:Data?,_ err:String?) -> Void)){
        if let authHeader = self.authHeader {
            request.addValue("Bearer \(authHeader)", forHTTPHeaderField:"Authorization" )
        }
        requestSession(request: self.request) { (res, err) in
            completion(res,err)
        }
    }
    /// Does Post request. Its suitable to use this method when update data on the server.
    /// - Parameter postString: The HTTP put string that will evaulate on the serverside.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func PUTRequest(postString:String,completion: @escaping((_ res:Data?,_ err:String?) -> Void)){
        if let authHeader = self.authHeader {
            request.addValue("Bearer \(authHeader)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = postString.data(using: .utf8)
        requestSession(request: self.request) { (res, err) in
            completion(res,err)
        }
    }
    /// Does Post request. Its suitable to use this method when delete data on the server.
    /// - Parameter postString: The HTTP delete string that will evaulate on the serverside.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func DELETERequest(postString:String,completion: @escaping((_ res:Data?,_ err:String?) -> Void)){
        if let authHeader = self.authHeader {
            request.addValue("Bearer \(authHeader)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = postString.data(using: .utf8)
        requestSession(request: self.request) { (res, err) in
            completion(res,err)
        }
    }
    
    /// This is the common method that will do the data request with 'URLSession' class.
    /// - Parameter request: The request object that will be executed.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func requestSession(request:URLRequest, callback:@escaping (_:Data?, _ error:String?) -> ()){
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(nil,error?.localizedDescription)
                if(!(request.url?.absoluteString.contains("checkin/current"))!){
                    self.showStatusBarNotification(title: (error?.localizedDescription)!, type: .warning)
                }
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                guard let fetchedJson = JsonFetcher.fetchJSON(data: data) else {
                    return
                }
                
                guard let modeledError = ErrorModel(json:fetchedJson) else {
                    return
                }
                callback(nil,modeledError.error)
                if(modeledError.error != "No current checkin found for the user"){
                    self.promptLogin()
                }

                return
            }
            
            
            callback(data,nil)
            
        }
        task.resume()
    }
    /// Shows a status bar notification banner whenever an HTTP error occurs.
    /// - Parameter title: Title of the banner that will be shown.
    /// - returns: Void
    func showStatusBarNotification(title:String, type:BannerStyle){
        DispatchQueue.main.async {
            let banner = StatusBarNotificationBanner(title: title, style: type)
            banner.show(queuePosition: .front)
        }
    }
    /// This method will be executed whenever an auth error occurs. This method will be executed and the user will be redirected on the login page.
    /// - returns: Void
    func promptLogin(){
        DispatchQueue.main.async {
            if let vc = UIApplication.topViewController() as? CheckinViewController{
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Auth")
                vc.present(controller, animated: true, completion: nil)
            }  
        }
    }
    
    /// Initializer of the HTTP request. This method will decide what type will be the request. And this method prepares the request object that will be used on 'requestSession()' method. 
    /// - Parameter url: url of the request. e.g. http://www.google.com/
    /// - Parameter type: type of the request
    /// - returns: Void
    func initializeRequest(url:String,type:RequestType){
        self.request = URLRequest(url: URL(string:url)!)
        if let token = UserDefaults.standard.string(forKey: "Auth"){
            self.authHeader = token 
        }else{
            promptLogin()
        }
        switch type {
        case .GET:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            break
        case .POST:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            break
        case .MultipartPOST:
            request.setValue("multipart/form-data; boundary=\(boundary!)", forHTTPHeaderField: "content-type")
            request.httpMethod = "POST"
            break
        case .PUT:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            break
        case .DELETE:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "DELETE"
            break
        }
    }
}
