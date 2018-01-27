//
//  APIOccupation.swift
//  Linky
//
//  Created by Alican Yilmaz on 18/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation

/// Api endpoint when fetching occupations.
class APIOccupation:APIBASE {
    /// Use this method to fetch the occupations when determining user's interested fields.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func fetch(completion: @escaping (_ res:Occupation?,_ err:String?) -> ()){
        requester = RequestMaster(url:occupationEndpoint , type: .GET)
        requester.GETRequest(completion: {res,err in 
            guard let result = res, err == nil else{
                completion(nil,err)
                return
            } 
            guard let fetchedJson = JsonFetcher.fetchJSON(data: result) else {
                completion(nil,"Error: Failed to parse json the response")
                return
            }
            guard let modeledOccupation = Occupation(json:fetchedJson) else {
                completion(nil,"Error: Failed to model json of response")
                return
            }
            completion(modeledOccupation,err)
        })
    }
    
    
}
