//
//  APIMatch.swift
//  Linky
//
//  Created by Alican Yilmaz on 22/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation

/// API endpoint of the match endpoint.
class APIMatch: APIBASE{
    /// Use this method to get current matches of current user.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func getMatches(completion: @escaping (_ res:[Match]?, _ err:String?) -> Void){
        self.requester = RequestMaster(url: getMatchesEndpoint, type: .GET)
        requester.GETRequest { (data, err) in
            guard let _ = data, err == nil else {
                completion(nil,err)
                return
            }
            let fetched = JsonFetcher.fetchJSON(data: data!)
            let innerData = fetched!["matches"] as? [[String: Any]]
            var matches = [Match]()
            for key in innerData! {
                let match = Match(json: key)
                matches.append(match!)
            }
            completion(matches,nil)
        }
    }
}

