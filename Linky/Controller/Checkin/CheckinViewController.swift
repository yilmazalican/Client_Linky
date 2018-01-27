//
//  FirstViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 17/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import NotificationBannerSwift
class CheckinViewController: UIViewController, CheckinDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var location: CLLocation?
    var api =  APICheckin()
    var apim =  APIMatch()
    var current: CheckinModel?
    var locationUsageBanner:NotificationBanner!
    var isDisplayingUsageBanner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationUsageBanner = NotificationBanner(title: "Critical", subtitle: "You must be in your range to get matched!", leftView: nil, rightView: UIImageView(image: UIImage(named:"danger")), style: .danger, colors: nil)
        locationUsageBanner.autoDismiss = false
        locationUsageBanner.delegate = self
        self.startTracking()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
            mapView.delegate = self
            getCurrent()
            UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {    
            if let current = current {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance((current.coordinate),0.5,0.5)
            mapView.setRegion(coordinateRegion, animated: true) 
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CheckinPopUpViewController
        vc.delegate = self
        if segue.identifier == "newCheckinSegue" {
            vc.checkinginLocation.append(Double(location!.coordinate.longitude))
            vc.checkinginLocation.append(Double(location!.coordinate.latitude))
            vc.currentCheckin = self.current
        }else{
            let vc = segue.destination as! CheckinPopUpViewController
            vc.isUserEditing = true
        }
    }
    
    func loadCurrentCheckin() {
            getCurrent() 
    } 
    
    func failedLoad(error:String) {
        
    }
    
}

