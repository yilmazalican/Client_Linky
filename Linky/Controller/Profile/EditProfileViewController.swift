//
//  EditProfileViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 29/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let api = APIUserProfile()
    let apiImg = APIProfileImage()

    @IBOutlet weak var changeInterestBtn: UIButton!
    @IBOutlet weak var aboutTxtView: UITextView!
    @IBOutlet weak var profilePictureImg: UIImageView!
    @IBOutlet weak var surnameTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    lazy var occupations = [String]()
    let imagePicker = UIImagePickerController()
    var apiEdit = APIEditProfile()
    var imageChanged = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePictureImg.contentMode = .scaleAspectFit
        imagePicker.delegate = self  
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.aboutTxtView.setBorder()
        api.getProfileOfCurrent { (user, err) in
            if (err != nil){

            }else{
                DispatchQueue.main.async {
                    self.surnameTxtField.text = user?.surname
                    self.nameTxtField.text = user?.name
                    self.aboutTxtView.text = user?.about
                    self.occupations = (user?.interested)!
                    self.apiImg.getProfileImage(of: (user?.id)!, completion: { (data, err) in
                        if err == nil {
                            DispatchQueue.main.async {
                                self.profilePictureImg.image = UIImage(data: data!)
                            }
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        guard let aboutTxtView = aboutTxtView.text,!aboutTxtView.isEmpty else{
            self.aboutTxtView.shake()
            return
        }
        guard let nameTxtField = nameTxtField.text,!nameTxtField.isEmpty else{
            self.nameTxtField.shake()
            return
        }
        guard let surnameTxtField = surnameTxtField.text,!surnameTxtField.isEmpty else{
            self.surnameTxtField.shake()
            return
        }
        
        guard self.occupations.count > 0 else{
            changeInterestBtn.shake()
            return
        }

        
        apiEdit.editProfile(name: nameTxtField, surname: surnameTxtField, about: aboutTxtView, occupations: self.occupations) { (completed, err) in
            if(err == nil){
                if(self.imageChanged){
                    DispatchQueue.main.async {
                        self.apiImg.uploadProfilePicture(imgdata: UIImageJPEGRepresentation(self.profilePictureImg.image!, 0.25)!, completion: { (res, err) in
                            DispatchQueue.main.async {
                                    self.profilePictureImg.image = self.profilePictureImg.image  
                                    self.dismiss(animated: true, completion: nil)
                            }
                        })   
                    }
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }


        
    }
    @IBAction func changeProfilePictureTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func changeInterestsTapped(_ sender: UIButton) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePictureImg.image = pickedImage
            self.imageChanged = true
            dismiss(animated: true, completion:nil)
        }
    }
    
}
