//
//  APICheckin.swift
//  Linky
//
//  Created by Alican Yilmaz on 19/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import CoreLocation
/// This is API endpoint of checkin endpoint of the server.
class APICheckin: APIBASE {
    
    /// Use this method to check-in a user to a specific geographic 2D location.
    /// - Parameter longitude: longitude of the coordinate.
    /// - Parameter latitude: latitude of the coordinate.
    /// - Parameter range: range of the checkin. This must be between 1000m and 1500m.
    /// - Parameter near: near field of the checkin. E.g. near California
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    public func checkin(longitude:Double, latitude:Double, range:Int, near:String, completion: @escaping (_ res:String?,_ err:String?) -> ()){
        self.requester = RequestMaster(url: createCheckinEndpoint, type: .POST)
        requester.POSTrequest(postString: "loc[0]=\(longitude)&loc[1]=\(latitude)&range=\(range)&near=\(near)") { (resData, err) in
            if(err == nil){
                completion("OK",nil)
            }else{
                completion(nil,err)
            }
        }
    }
    /// Use this method to get current checkin of the user if there is any.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    public func getCurrent(completion: @escaping (_ res:CheckinModel?, _ err:String?) -> Void){
            self.requester = RequestMaster(url: self.getCurrentCheckinEndpoint, type: .GET)
            self.requester.GETRequest { (data, err) in
                if (err == nil){
                    let fetchedJson = JsonFetcher.fetchJSON(data: data!)
                    let checkin = Checkin(json: fetchedJson!)!
                    var location = CLLocationCoordinate2D()
                    location.longitude = Double(checkin.loc[0])
                    location.latitude = Double(checkin.loc[1])
                    let modeledCheckin = CheckinModel(coordinate:location, id:checkin.id,searchable: checkin.searchable, isCurrent: checkin.isCurrent, range: checkin.range,createdAt: checkin.createdAt, near:checkin.near)
                    completion(modeledCheckin,err)

                }else{
                 completion(nil,err) 
                }
            }
    }
    /// Use this method to edit check-in a user to a specific geographic 2D location.
    /// - Parameter range: range of the checkin.
    /// - Parameter searchable: searchable field of the check-in. If this is false, the checkin is not matchable.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    public func editCurrent(range:Int,searchable:Bool,completion: @escaping (_ err:String?) -> Void){
        self.requester = RequestMaster(url: self.editCurrentCheckinEndpoint, type: .PUT)
        self.requester.PUTRequest(postString:"range=\(range)&searchable=\(searchable)") { (data, err) in
            completion(err)
        }       
    }
}
