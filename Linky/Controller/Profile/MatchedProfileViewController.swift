//
//  MatchedProfileViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 07/12/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import UIKit
class MatchedProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {  
    @IBOutlet weak var interestTV: UIImageView!
    @IBOutlet weak var nameTxtField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var aboutTextField: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    var user:User!
    var apiImg = APIProfileImage()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.nameTxtField.text = self.user.name
        self.emailTextField.text = self.user.email
        self.aboutTextField.text = self.user.about
        self.title = "\(user.name)'s Profile"

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.interested.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestedCell")
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell?.textLabel?.text = self.user.interested[indexPath.row]
        return cell!    
        
    }
}
