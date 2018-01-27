//
//  CheckinErrors.swift
//  Linky
//
//  Created by Alican Yilmaz on 22/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import CoreLocation
extension CheckinViewController {
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return isLocationAvailable()
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}
