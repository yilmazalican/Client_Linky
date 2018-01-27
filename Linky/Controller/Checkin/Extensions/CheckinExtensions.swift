//
//  CheckinExtensions.swift
//  Linky
//
//  Created by Alican Yilmaz on 19/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import NotificationBannerSwift
extension CheckinViewController:CLLocationManagerDelegate,MKMapViewDelegate, NotificationBannerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        self.location = location
        self.title = "\(String(Int(location!.horizontalAccuracy)))m"
        self.mapView.setUserTrackingMode( .follow, animated: true)
        if let current = self.current {
            requestRegionState(checkin: current)
        }
    }
    
    
    func startTracking(){
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true  
        }
    }
    
    
    func isLocationAvailable() -> Bool{
        if(self.location != nil && mapView.isUserLocationVisible){
            return true
        }
        let bar = StatusBarNotificationBanner(title: "Cannot determine location data", style: .warning, colors: nil)
        bar.show()
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if let current = self.current {
            DispatchQueue.main.async {
                if(state.rawValue == 2){
                    if(!self.isDisplayingUsageBanner){
                        self.locationUsageBanner.show(on:self)
                    }
                }else if(state.rawValue == 1){
                    if(self.isDisplayingUsageBanner){
                        self.locationUsageBanner.dismiss()
                    }
                    
                } 
            }
        }
    }
    
    
    func getCurrent(){
        self.api.getCurrent(completion: { (checkin, error) in
            DispatchQueue.main.async {
                guard let checkindata = checkin, error == nil else{
                    //If no checkin has been present, then stop monitor any.
                    for region in self.locationManager.monitoredRegions{
                        self.locationManager.stopMonitoring(for: region)
                    }
                    self.current = nil
                    self.clearAnnotationAndRange()
                    if(self.isDisplayingUsageBanner){
                        self.locationUsageBanner.dismiss()
                    }
                    return
                }
                
                //If a new checkin has been added by pop-up
                if let current = self.current {
                    if(checkin!.id != current.id){
                        self.stopMonitoring(checkin: current)
                    }
                }
                //If logged in another phone, just reinitialize current geofence
                if(CLLocationManager().monitoredRegions.count == 0){
                    self.startMonitoring(checkin: checkindata)   
                }
                
                
                //just  initialize checkin and add anotationView.
                checkindata.title = "Range: \(checkindata.range)m"
                self.addAnnotationAndRange(checkin: checkindata)
                self.current = checkindata 
                self.requestRegionState(checkin: checkindata)
                
            }
            
            
        })
    }
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        self.isDisplayingUsageBanner = true
    }
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        self.isDisplayingUsageBanner = true
        
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        self.isDisplayingUsageBanner = false
        
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        self.isDisplayingUsageBanner = false
        
    }
    
    func region(checkin:CheckinModel) -> CLCircularRegion{
        let region = CLCircularRegion(center: checkin.coordinate, radius:Double(checkin.range), identifier: checkin.id)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func requestRegionState(checkin:CheckinModel){
        let region = self.region(checkin: checkin)
        locationManager.requestState(for: region)
    }
    
    func startMonitoring(checkin: CheckinModel){
        let region = self.region(checkin: checkin)
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(checkin:CheckinModel){
        for region in (self.locationManager.monitoredRegions){
            let circularRegion = region as? CLCircularRegion
            locationManager.stopMonitoring(for: circularRegion!)        
        }
    }
}
