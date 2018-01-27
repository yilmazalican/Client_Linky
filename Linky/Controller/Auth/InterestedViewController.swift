//
//  InterestedViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 18/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit

class InterestedViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var api:APIOccupation!
    lazy var occupations = [String]()
    lazy var filteredOccupations = [String]()
    var searchController = UISearchController(searchResultsController: nil)
    lazy var selectedItems = [String]()
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSearchController()
        api = APIOccupation()
        api.fetch(completion:{ res,err in
            guard let response = res, err == nil else {
                return
            }
            DispatchQueue.main.async {
             self.occupations = response.occupations
             self.tableView.reloadData()
            }
        })
        guard getRegisterVC()!.occupations.count > 0 else{
            return 
        }
        self.selectedItems = getRegisterVC()!.occupations
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
            selectedItems.append(filteredOccupations[indexPath.row])
            
        }else{
            selectedItems.append(occupations[indexPath.row])
            
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
        searchController.searchBar.tintColor = UIColor.white
       
    }
    
    
    func getRegisterVC() -> RegisterViewController? {
        if let NG = self.parent?.presentingViewController?.childViewControllers {
            for vcs in NG{
                if let _vcs = vcs as? RegisterViewController{
                    return _vcs
                }
            } 
            
        }
        return nil
    }
    
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        getRegisterVC()!.occupations = self.selectedItems
        self.dismiss(animated: true, completion: nil)    
    }
    
}



