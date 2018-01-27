//
//  LoginViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 17/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController, UITextFieldDelegate {   
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var httpAuth:APIAuthentication!
    var deviceAPI: APIDeviceToken!
    override func viewDidLoad() {
        super.viewDidLoad()
        httpAuth = APIAuthentication()
        deviceAPI = APIDeviceToken()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.shake()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else{
            passwordTextField.shake()
            return
        }
        self.httpAuth.login(email: email, password: password, completion: {res,err in 
            guard let response = res, err == nil else{
                self.emailTextField.shake()
                self.passwordTextField.shake()
                return
            }
            UserDefaults.standard.set(response, forKey: "Auth")
            if let token = UserDefaults.standard.string(forKey: "Auth") {
                APISocket.shared.establishConnection(token: "Bearer \(token)")
            }
            if let token = UserDefaults.standard.string(forKey: "DeviceToken") {
                self.deviceAPI.registerDevice(with:token , completion: { (res, err) in
                    if(err == nil){
                        self.dismiss(animated: true, completion: nil)   
                    }
                })
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }) 
    }
    
    
}
