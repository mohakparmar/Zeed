//
//  ProfileSellerAuctionsCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class ProfileSellerAuctionsCell: UITableViewCell {
    //MARK: - Properties
    var obj : SellerStatastics? {
        didSet {
            ongoingNumber.text = obj?.ongoingAuction
            completedNumber.text = obj?.completedAuction
        }
    }
    
    //MARK: - UI Elements
    private let ongoingLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? On_Going_ar : On_Going_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let ongoingNumber: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let completedLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Completed_ar : Completed_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let completedNumber: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
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
        backgroundColor = .white
        
        layer.cornerRadius = 20
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.appPrimaryColor.cgColor
        
        let ongoingStack = UIStackView(arrangedSubviews: [ongoingLabel, ongoingNumber])
        ongoingStack.axis = .vertical
        ongoingStack.alignment = .center
        ongoingStack.spacing = 4
        ongoingStack.backgroundColor = .white
        ongoingStack.distribution = .fillEqually
        
        let completedStack = UIStackView(arrangedSubviews: [completedLabel, completedNumber])
        completedStack.axis = .vertical
        completedStack.alignment = .center
        completedStack.spacing = 4
        completedStack.backgroundColor = .white
        completedStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [ongoingStack, completedStack])
        mainStack.alignment = .center
        mainStack.distribution = .fillEqually
        mainStack.spacing = 1
        mainStack.axis = .horizontal
        mainStack.backgroundColor = .appPrimaryColor
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
