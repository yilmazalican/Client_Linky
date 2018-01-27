//
//  UserProfileViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 29/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit
class UserProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var interestTV: UITableView!
    
    let api = APIUserProfile()
    let apiImg = APIProfileImage()
    let deviceAPI = APIDeviceToken()
    var user:User!
    var interested = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        interestTV.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        api.getProfileOfCurrent { (user, err) in
            guard let user = user, err == nil else{
                return
            }
            self.navigationItem.title = "\(user.name)'s Profile"
            DispatchQueue.main.async {
                self.interested = user.interested
                self.interestTV.reloadData()
                self.aboutLbl.text = user.about
                self.emailLbl.text = user.email
                self.nameLbl.text = "\(user.name) \(user.surname)"
                self.apiImg.getProfileImage(of: user.id, completion: { (imgData, err) in
                    guard let imgData = imgData, err == nil else{
                        DispatchQueue.main.async {
                            self.profileImg.image = UIImage(named:"businessman")
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        self.profileImg.image = UIImage(data: imgData)
                    }
                })
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.interested.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestedCell")
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell?.textLabel?.text = self.interested[indexPath.row]
        return cell!
    }
    
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        if let token = UserDefaults.standard.string(forKey: "DeviceToken") {
            self.deviceAPI.unregisterDevice(with:token , completion: { (res, err) in
                DispatchQueue.main.async {
                    UserDefaults.standard.removeObject(forKey: "Auth")
                    let vc = self.tabBarController?.selectedViewController as? CheckinViewController
                    vc?.locationManager.stopUpdatingLocation()
                    self.tabBarController?.selectedIndex = 0   
                }
            })
        }
        UserDefaults.standard.removeObject(forKey: "Auth")
        APISocket.shared.disconnectSocket()
        let vc = self.tabBarController?.selectedViewController as? CheckinViewController
        vc?.locationManager.stopUpdatingLocation()
        self.tabBarController?.selectedIndex = 0   
        
    }
    
    
}
