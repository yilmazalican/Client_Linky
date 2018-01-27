//
//  AppDelegate.swift
//  Linky
//
//  Created by Alican Yilmaz on 16/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import CoreLocation
import NotificationBannerSwift
import Photos
import SocketIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager() 
    let deviceToken: String = ""
    var api:APICheckin!
    let center = UNUserNotificationCenter.current()
    
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "MySession")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.api = APICheckin()
        if let token = UserDefaults.standard.string(forKey: "Auth") {
            APISocket.shared.establishConnection(token: "Bearer \(token)")
        }
        UIApplication.shared.statusBarStyle = .lightContent
        locationManager.delegate = self
        center.delegate = self
        locationManager.requestAlwaysAuthorization()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { (granted, err) in
            if(!granted){
                DispatchQueue.main.async {
                    let banner = StatusBarNotificationBanner(title: "You will not get notifications unless you authorize it.", style: .warning, colors: nil)
                    banner.show()  
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        return true  
    }
 
    
    
    func handleEvent(forRegion region: CLRegion!) {
        if UIApplication.shared.applicationState != .active {
            let content = UNMutableNotificationContent()
            content.title = "Checkin"
            content.body = "Please get back to your check-in area to continue to get matched with people."
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, 
                                                            repeats: false)
            let requestIdentifier = "RegionChangeNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier, 
                                                content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
            center.removeDeliveredNotifications(withIdentifiers: ["RegionChangeNotification"])
        }
    }
    
 
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        DispatchQueue.main.async {
            let banner = NotificationBanner(title: "Heyyo!", subtitle: notification.request.content.body, leftView: nil, rightView: UIImageView(image: UIImage(named:"success")), style: .success, colors: nil)
            banner.show()
        }
    }
    



}
extension AppDelegate: CLLocationManagerDelegate {
    
    func backgroundURLRequest(url:String, body:String){
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)
        request.setValue("Bearer \(String(describing: UserDefaults.standard.string(forKey: "Auth")!))", forHTTPHeaderField: "Authorization")
        self.urlSession.dataTask(with: request).resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
            backgroundURLRequest(url: "http://104.45.22.103:4000/checkin/edit", body: "searchable=false")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        backgroundURLRequest(url: "http://104.45.22.103:4000/checkin/edit", body: "searchable=true")
    }
    

}
extension AppDelegate{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        UserDefaults.standard.set(token, forKey: "DeviceToken")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let token = UserDefaults.standard.string(forKey: "Auth") {
            APISocket.shared.establishConnection(token: "Bearer \(token)")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        APISocket.shared.disconnectSocket()
    }
    

  
}




