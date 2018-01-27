//
//  ChatViewController.swift
//  Linky
//
//  Created by Alican Yilmaz on 26/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit
import KeyboardObserver
import Kingfisher


class ChatViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var user:User?
    var needToScroll: Bool = false
    @IBOutlet weak var titleBtn: UIButton!
    var messages = [Message]()
    var imageCache = NSCache<NSString, AnyObject>()
    var sendButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBtn.setTitle("\(self.user!.name)'s Profile", for: .normal)       
        collectionView.delegate = self
        inputTextField.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        let flowLayout: UICollectionViewFlowLayout =  {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.estimatedItemSize = CGSize(width: 50, height: 50)
            return flowLayout
        }()
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = flowLayout
        collectionView.keyboardDismissMode = .interactive
        self.collectionView.backgroundColor = UIColor(r: 236, g: 240, b: 241)
        bindSocket()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        APISocket.shared.socket.emit("openvc", ["requesteduserid":self.user!.id])
        APISocket.shared.socket.emit("get conversations", ["requesteduserid":self.user!.id])
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        APISocket.shared.socket.off("send conversation")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    @IBAction func showProfile(_ sender: Any) {
        performSegue(withIdentifier: "ShowProfileSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MatchedProfileViewController{
            vc.user = self.user
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        APISocket.shared.socket.emit("closevc", ["requesteduserid":self.user!.id])
        APISocket.shared.socket.off("send conversation")
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    
    @objc func sendMessageButtonTapped() {
        APISocket.shared.socket.emit("new message", ["requesteduserid":self.user!.id , "message": inputTextField.text!])
        self.inputTextField.text = ""
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatCollectionViewCell
        let date = self.messages[indexPath.row].getDateOfMe()
        cell.txtLbl.text = self.messages[indexPath.row].message
        cell.nameLbl.text = self.messages[indexPath.row].name
        cell.dateLbl.text = TimeAgo.timeAgoSinceDate(date: date! as NSDate, numericDates: true)
        cell.image.kf.setImage(with: URL(string:"http://104.45.22.103:4000/profileimage/\(String(describing: self.messages[indexPath.row].author!))"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    
    
    func bindSocket(){
        APISocket.shared.socket.on("send conversation") { (data, ack) in
            
            let dataFromString = String(describing: data[0]).data(using: .utf8)
            do {
                let modeledMessage = try JSONDecoder().decode(Conversation.self, from: dataFromString!)
                DispatchQueue.main.async {
                    if(modeledMessage.p1! == self.user!.id || modeledMessage.p2! == self.user!.id){
                        self.messages = modeledMessage.messages!
                        self.collectionView.reloadData()    
                    }
                }  
            } catch  {
                //error occured!
            } 
        }
        
        
        
        
    }
}

