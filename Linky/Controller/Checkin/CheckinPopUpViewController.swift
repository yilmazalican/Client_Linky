//
//  CheckinPopUpViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 19/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit
import CoreLocation

protocol CheckinDelegate: class{
    func loadCurrentCheckin()
    func failedLoad(error:String)

}

class CheckinPopUpViewController: UIViewController {
    @IBOutlet weak var subView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var metersLabel: UILabel!
    var checkinginLocation = [Double]()
    var currentCheckin:CheckinModel?
    let api = APICheckin()
    var isUserEditing:Bool?
    
    weak var delegate:CheckinDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareGestureRecognizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.rangeSlider.value = 50
    }
    
    @objc func handleTapFrom(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
        self.isUserEditing = nil
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        metersLabel.text = "\(String(Int(sender.value)))m"
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == mainView
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        self.displayLoadingAlert()
        if let _ = isUserEditing{
            self.api.editCurrent(range: Int(self.rangeSlider.value),searchable: true, completion: { (err) in
                self.disAppearLoadingAlert(completion: {                     
                    if err == nil {
                        if let delegate = self.delegate {
                            delegate.loadCurrentCheckin()
                            self.dismiss(animated: true, completion: nil)
                            return
                        }  
                    }
                })
            })
            
        }else{
            let location = CLLocation(latitude: self.checkinginLocation[1], longitude: self.checkinginLocation[0])
            getNearbyLocation(location: location, completion: { (name) in
                self.api.checkin(longitude: self.checkinginLocation[0], latitude: self.checkinginLocation[1], range: Int(self.rangeSlider.value), near:name) { (res, err) in
                    self.disAppearLoadingAlert(completion: { 
                        if let error = err {
                            self.dismiss(animated: true, completion: nil)
                            self.delegate?.failedLoad(error: error)
                            return  
                        }else{
                            if let delegate = self.delegate {
                                delegate.loadCurrentCheckin()
                                self.dismiss(animated: true, completion: nil)
                                return
                            }
                        }                
                    })  
                }
                self.isUserEditing = nil 
            })
        }
    }
    
    func getNearbyLocation(location:CLLocation, completion: @escaping (((String) -> Void))) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (mark, err) in
            if let placeMark = mark?[0]{
                if let name = placeMark.name {
                   completion(name)
                    return
                }else{
                    if let name = placeMark.locality {
                        completion(name)
                        return
                    }
                }
            }
        }
    }
}

extension CheckinPopUpViewController:UIGestureRecognizerDelegate{
    func prepareGestureRecognizer(){
        self.view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(sender:)))
        self.mainView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self  
    }
}
