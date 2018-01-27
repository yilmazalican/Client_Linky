//
//  chatCollectionViewCell.swift
//  Linky
//
//  Created by Alican Yilmaz on 26/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    let txtLbl: UILabel = {
        let textlbl = UILabel()
        textlbl.translatesAutoresizingMaskIntoConstraints = false
        textlbl.backgroundColor = UIColor.clear
        textlbl.textColor = UIColor.black
        textlbl.font = UIFont (name: "Avenir-Book", size: 14)
        textlbl.numberOfLines = 999
        return textlbl
    }()
    
    let bubleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let image:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named:"2")
        view.frame.size.width = 35
        view.frame.size.height = 35
        view.layer.cornerRadius = view.frame.size.width / 2.0
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let nameLbl:UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont (name: "Avenir-Heavy", size: 15)
        view.text = "Alican Yilmaz"
        return view
    }()
    
    let dateLbl:UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont (name: "Avenir-Book", size: 12)
        view.textColor = UIColor.gray
        view.text = "5 days ago"
        return view
    }()
    
    var isHeightCalculated = false
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
        
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        
        contentView.addSubview(bubleView)
        contentView.addSubview(txtLbl)
        contentView.addSubview(image)
        contentView.addSubview(nameLbl)
        contentView.addSubview(dateLbl)
        
        
        nameLbl.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        nameLbl.leftAnchor.constraint(equalTo:txtLbl.leftAnchor).isActive = true
        
        bubleView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        bubleView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        bubleView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        bubleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        txtLbl.leftAnchor.constraint(equalTo: self.bubleView.leftAnchor, constant:50).isActive = true
        txtLbl.rightAnchor.constraint(equalTo: self.bubleView.rightAnchor,constant:-15).isActive = true
        txtLbl.topAnchor.constraint(equalTo: self.nameLbl.bottomAnchor).isActive = true
        txtLbl.bottomAnchor.constraint(equalTo: self.bubleView.bottomAnchor).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 35).isActive = true
        image.heightAnchor.constraint(equalToConstant: 35).isActive = true
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:7.5).isActive = true
        
        dateLbl.leftAnchor.constraint(equalTo: nameLbl.rightAnchor,constant:10).isActive = true
        dateLbl.topAnchor.constraint(equalTo: nameLbl.topAnchor,constant:3).isActive = true
        self.isHeightCalculated = true 
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
