//
//  InterestedViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 18/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class EditOccupationViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var api:APIOccupation!
    var apiUser:APIUserProfile!
    
    lazy var occupations = [String]()
    lazy var filteredOccupations = [String]()
    var searchController = UISearchController(searchResultsController: nil)
    lazy var selectedItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSearchController()
        api = APIOccupation()
        apiUser = APIUserProfile()
        api.fetch(completion:{ res,err in
            guard let response = res, err == nil else {
                return
            }
            DispatchQueue.main.async {
                self.occupations = response.occupations
                self.tableView.reloadData()
            }
        })
        
        apiUser.getProfileOfCurrent { (user, err) in
            if(err != nil){
                for item in (user?.interested)!{
                    self.occupations.append(item)
                }
            }
        }
        
        guard getEditProfileVC()!.occupations.count > 0 else{
            return 
        }
        self.selectedItems = getEditProfileVC()!.occupations
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filteredOccupations = occupations.filter({(occupation:String) -> Bool in 
            return occupation.lowercased().contains(searchText!.lowercased())
        })
        tableView.reloadData()      
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && (!searchBarIsEmpty())
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "occupationcell", for: indexPath)
        if(isFiltering()){
            if(selectedItems.contains(filteredOccupations[indexPath.row])){
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            cell.textLabel?.text = filteredOccupations[indexPath.row]
        }else{
            if(selectedItems.contains(occupations[indexPath.row])){
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            cell.textLabel?.text = occupations[indexPath.row]
            
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltering()){
            return filteredOccupations.count
        }
        return self.occupations.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isFiltering()){
            if(!selectedItems.contains(filteredOccupations[indexPath.row])){
                selectedItems.append(filteredOccupations[indexPath.row])
            }
            
        }else{
            if(!selectedItems.contains(occupations[indexPath.row])){
                selectedItems.append(occupations[indexPath.row])
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if(isFiltering()){
            let index = selectedItems.index(of: filteredOccupations[indexPath.row])
            selectedItems.remove(at: index!)
            
        }else{
            let index = selectedItems.index(of: occupations[indexPath.row])
            selectedItems.remove(at: index!)
        }
    }
    
    func initializeSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Occupations"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    
    func getEditProfileVC() -> EditProfileViewController? {
        if let NG = self.parent?.presentingViewController?.childViewControllers {
            for vcs in NG{
                if let _vcs = vcs as? EditProfileViewController{
                    return _vcs
                }
            } 
            
        }
        return nil
    }
    
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        getEditProfileVC()!.occupations = self.selectedItems
        self.dismiss(animated: true, completion: nil)    
    }
    
}




