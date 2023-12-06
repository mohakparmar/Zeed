//
//  ProfileSellerActionButtonCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class ProfileSellerActionButtonCell: UITableViewCell {
    //MARK: - Properties
    
    var isForEditProfile : Bool = false
    
    private let requestButton: UIView = {
        let customView = UIView()
        customView.backgroundColor = .white
        customView.isUserInteractionEnabled = true

        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Request_Sales_Report_ar : Request_Sales_Report_en, for: .normal)
        button.tintColor = .black
        button.titleLabel?.contentMode = .left
        button.isUserInteractionEnabled = false
//        button.addTarget(ProfileSellerActionButtonCell.self, action: #selector(actionWithoutParam), for: .touchUpInside)

        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "invoice").withRenderingMode(.alwaysOriginal)
        imageView.setDimensions(height: 22, width: 22)
        
        let mainStack = UIStackView(arrangedSubviews: [imageView, button])
        mainStack.spacing = 10
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        
        customView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        
        return customView
    }()
    
    @objc func actionWithoutParam(){
        //...
    }

    //MARK: - Selectors
    @objc func callRequetStatement() {
        Service.shared.requestSalesReport(completion: { status, message in
            if status {
                Utility.showISMessage(str_title: "Report sent successfully.", Message: "", msgtype: .success)
            } else {
                Utility.showISMessage(str_title: message ?? "", Message: "", msgtype: .warning)
            }
        })
    }
    

    private let editBusinessButton: UIView = {
        let customView = UIView()
        customView.backgroundColor = .white
        customView.isUserInteractionEnabled = true
        
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Edit_Business_Profile_ar : Edit_Business_Profile_en, for: .normal)
        button.tintColor = .black
        button.titleLabel?.contentMode = .left
//        button.addTarget(ProfileSellerActionButtonCell.self, action: #selector(ProfileSellerActionButtonCell.actionWithoutParam), for: .touchUpInside)
        button.isUserInteractionEnabled = false

        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "pen").withRenderingMode(.alwaysOriginal)
        imageView.setDimensions(height: 22, width: 22)
        
        let mainStack = UIStackView(arrangedSubviews: [imageView, button])
        mainStack.spacing = 10
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        
        customView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        
        return customView
    }()
    //MARK: - UI Elements
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureUI() {
        backgroundColor = .clear
        
        requestButton.layer.cornerRadius = 45/2
        editBusinessButton.layer.cornerRadius = 45/2
         
        var mainStack = UIStackView(arrangedSubviews: [requestButton])
        if self.isForEditProfile == true {
            mainStack = UIStackView(arrangedSubviews: [editBusinessButton])
        }
        mainStack.spacing = 10
        mainStack.distribution = .fillEqually
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        
        addSubview(mainStack)
        mainStack.fillSuperview()

        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }
    }
    
    @objc func actionWithParam(sender: UIButton){
        Service.shared.requestSalesReport(completion: { status, message in
            if status {
                Utility.showISMessage(str_title: "Report sent successfully.", Message: "", msgtype: .success)
            } else {
                Utility.showISMessage(str_title: message ?? "", Message: "", msgtype: .warning)
            }
        })
    }

}
