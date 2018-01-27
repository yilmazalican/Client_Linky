//
//  Extensions.swift
//  Linky
//
//  Created by Alican Yilmaz on 17/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import NotificationBannerSwift
import UIKit

/// UIView Extension
extension UIView {
    /// This method is userd to shake any UIView control like TextView or TextField.
    func shake() {
        DispatchQueue.main.async {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.duration = 0.6
            animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
            self.layer.add(animation, forKey: "shake")  
        }
    }
}

/// MVC extension
extension UIViewController {
    
    /// Use this method to display an alert on the screen and make it first responder.
    /// - Parameter title: title of the alert.
    /// - Parameter message: message of the alert.
    /// - Parameter buttonTitle: title of the action button.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func displayAlert(title:String,message:String,buttonTitle:String,completion: ((_ alert:UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: completion))
        self.present(alert, animated: true, completion: nil)
        
    }
    /// Use this method to display an loading alert on the screen and make it first responder.
    /// - Parameter title: title of the alert.
    /// - Parameter message: message of the alert.
    /// - Parameter preferredStyle: style of the alert.
    /// - Parameter completion: completion closure. This will execute whenever the request has been finished.
    /// - returns: Void
    func displayLoadingAlert(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)  
        }
    }
    
    /// Use this method to disapperar a loading alert on screen.
    func disAppearLoadingAlert(completion: (() -> Void)?){
        DispatchQueue.main.async {
            let presented = self.presentedViewController 
            presented?.dismiss(animated: true, completion: completion)     
        }
    }
    
    /// Use this method to show a statusbar notification banner on the screen.
    func showStatusBarNotification(title:String, type:BannerStyle){
        DispatchQueue.main.async {
            let banner = StatusBarNotificationBanner(title: title, style: type)
            banner.show(queuePosition: .front)
        }
    }
    
    
}

/// Extension of UIApplication.
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

/// Extension of UITextView.
extension UITextView {
    
    func setBorder(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func setPlaceHolder() {
        self.text = "Tell us about yourself..."
        self.textColor = UIColor.lightGray
    }    
}

/// Extension of Data.
extension Data {
    mutating func append(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}
/// Extension of UIColor.
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
/// Extension of UIImageView.

extension UIImageView{
    
    /// Use this method to download an image and cache it.
    /// - Parameter id: id of user.
    /// - Parameter cache: cache object that image will be cached.
    /// - Parameter tv: TableView that will be used.
    /// - returns: Void
    func downloadImage(id:String,cache:NSCache<NSString, AnyObject>, tv:UITableView){
        let api = APIProfileImage()
        api.getProfileImage(of: id) { (data, err) in
            DispatchQueue.main.async {
                if let data = data {
                    tv.reloadData()
                    let img = UIImage(data: data)
                    cache.setObject(img!, forKey: id as NSString)
                    self.image = img
                }else{
                    let img = UIImage(named:"businessman")
                    cache.setObject(img!, forKey: id as NSString)
                    self.image = img
                    tv.reloadData()
                }
            }
        }
    }
    /// Use this method to download an image and cache it.
    /// - Parameter id: id of user.
    /// - Parameter cache: cache object that image will be cached.
    /// - Parameter tv: CollectionView that will be used.
    /// - returns: Void
    func downloadImageCV(id:String,cache:NSCache<NSString, AnyObject>, cv:UICollectionView){
        APIProfileImage().getProfileImage(of: id) { (data, err) in
            DispatchQueue.main.async {
                if let data = data {
                    let img = UIImage(data: data)
                    cache.setObject(img!, forKey: id as NSString)
                    self.image = img
                }else{
                    let img = UIImage(named:"businessman")
                    cache.setObject(img!, forKey: id as NSString)
                    self.image = img
                    //cv.reloadData()
                }
            }
        }
    }
}
