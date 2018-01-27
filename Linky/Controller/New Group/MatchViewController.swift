//
//  MatchViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 23/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let imgapi = APIProfileImage() 
    var api = APIMatch()
    var matches = [Match]()
    var user: User!
    var imageCache = NSCache<NSString, AnyObject>()
    
    @IBOutlet weak var matchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.matchTableView.delegate = self
        matchTableView.tableFooterView = UIView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        api.getMatches { (match, err) in
                if let match = match {
                    if (match.count > 0) {
                        self.matches = match
                        DispatchQueue.main.async {
                            self.matchTableView.backgroundView = UIView()
                            self.matchTableView.reloadData()   
                        }
                        
                    }else{
                        
                        DispatchQueue.main.async {
                            self.matches = []
                            self.matchTableView.reloadData() 
                            let label = UILabel()
                            if let err = err {
                                label.text = err
                            }else{
                                label.text = "Uh oh, look around to find a match :)"
                            }
                            label.textAlignment = .center
                            self.matchTableView.backgroundView = label
                        }
                        
                    }
                }else{
                    self.matches = []
                    DispatchQueue.main.async {
                        self.matchTableView.reloadData()  
                    }
                }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell") as? MatchTableViewCell
        {
            cell.profileImage.kf.setImage(with: URL(string:"http://104.45.22.103:4000/profileimage/\(String(describing: self.matches[indexPath.row].user.id))"))
            cell.nameLbl.text = "\(self.matches[indexPath.row].user.name) \(self.matches[indexPath.row].user.surname)"
            cell.whenLbl.text = "\(TimeAgo.timeAgoSinceDate(date: self.matches[indexPath.row].createdAt as NSDate, numericDates: true))"
            cell.nearLbl.text = "Near \(self.matches[indexPath.row].checkin.near)"
            return cell 
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.user = self.matches[indexPath.row].user
        performSegue(withIdentifier: "ChatSegue", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChatViewController {
            destination.user = self.user
        }
    }
}




