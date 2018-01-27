//
//  Checkin.swift
//  Linky
//
//  Created by Alican Yilmaz on 19/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
/// Model of checkin object. This is the model whenever parse json object into raw swift objects.
struct Checkin {
    
    var id:String
    var searchable:Bool
    var isCurrent:Bool
    var range:Int
    var loc: [Double]
    var createdAt: Date
    var near:String
    
    init?(json:[String:Any]){
        guard let id = json["_id"] as? String else{
            return nil
        }
        guard let near = json["near"] as? String else{
            return nil
        }
        guard let searchable = json["searchable"] as? Bool else{
            return nil
        }
        guard let isCurrent = json["isCurrent"] as? Bool else{
            return nil
        }
        guard let range = json["range"] as? Int else{
            return nil
        }
        guard let createdAt = json["createdAt"] as? String else{
            return nil
        }
        guard let loc = json["loc"] as? [Double] else{
            return nil
        }
        self.loc = loc
        self.isCurrent = isCurrent
        self.range = range
        self.id = id
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let myDate: Date? = dateFor.date(from: createdAt)
        self.createdAt = myDate!
        self.searchable = searchable
        self.near = near
    }
}


/// This is the concrete checkin object that is used on check-in related places.
class CheckinModel: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var id:String
    var searchable:Bool
    var isCurrent:Bool
    var range: Int
    var createdAt: Date
    var title: String!
    var near:String
    init(coordinate:CLLocationCoordinate2D, id:String,searchable:Bool,isCurrent:Bool,range:Int,createdAt:Date, near:String){
        self.coordinate = coordinate
        self.id = id
        self.searchable = searchable
        self.isCurrent = isCurrent
        self.range = range
        self.createdAt = createdAt
        self.near = near
    }
}


