//
//  JsonFetcher.swift
//  Linky
//
//  Created by Alican Yilmaz on 17/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation

/// This class is responsible to fetch json from raw data object.
class JsonFetcher{
    /// Use this method to fet json from the data object.
    /// - Parameter data: data object that will be converted to json dictionary.
    /// - returns: [String:Any]
    static func fetchJSON(data:Data) -> [String:Any]?{
        do{
            if let todoJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                return todoJSON
            }
        }catch{
            return nil
        }
        return nil
    }
}
