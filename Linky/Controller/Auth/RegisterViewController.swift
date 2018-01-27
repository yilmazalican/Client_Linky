//
//  RegisterViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 17/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class RegisterViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var aboutTextArea: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var enterYourAreasButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    lazy var occupations = [String]()
    var api: APIRegister!
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIRegister()
        aboutTextArea.setPlaceHolder()
        aboutTextArea.setBorder()
        aboutTextArea.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        rePasswordTextField.delegate = self
        nameTextField.delegate = self
        surnameTextField.delegate = self
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func enterYourAreasTapped(_ sender: UIButton) {
        
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tell us about yourself..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else{
            nameTextField.shake()
            return
        }
        guard let surname = surnameTextField.text, !surname.isEmpty else{
            surnameTextField.shake()
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else{
            emailTextField.shake()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else{
            passwordTextField.shake()
            return
        }
        guard let repassword = rePasswordTextField.text, !repassword.isEmpty else{
            rePasswordTextField.shake()
            return
        }
        guard let about = aboutTextArea.text, about != "Tell us about yourself...", about != "" else{
            aboutTextArea.shake()
            return
        }
        
        guard let _repassword = rePasswordTextField.text, let _password = passwordTextField.text, _repassword == _password else{
            passwordTextField.shake()
            rePasswordTextField.shake()
            return
        }
        
        guard self.occupations.count > 0 else{
            enterYourAreasButton.shake()
            return
        }
        self.api.register(email: email, name: name, surname: surname, password: password, interests: occupations, about: about, completion: {res,err in 
            guard let _ = res, err == nil else{
                self.showStatusBarNotification(title: err!.description, type: .warning)
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        })
    }
}

