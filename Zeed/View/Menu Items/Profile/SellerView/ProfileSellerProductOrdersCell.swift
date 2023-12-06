//
//  ProfileSellerProductOrdersCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class ProfileSellerProductOrdersCell: UITableViewCell {
    //MARK: - Properties
    
    var obj : SellerStatastics? {
        didSet {
            pendingNumber.text = obj?.pendingCount
            deliveredNumber.text = obj?.deliveredCount
            canceledNumber.text = obj?.cancelledCount
        }
    }
    
    //MARK: - UI Elements
    private let pendingLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Pending_ar : Pending_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let pendingNumber: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let deliveredLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Delivered_ar : Delivered_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let deliveredNumber: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let canceledLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Cancelled_ar : Cancelled_en
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let canceledNumber: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .red
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
        
        let pendingStack = UIStackView(arrangedSubviews: [pendingLabel, pendingNumber])
        pendingStack.axis = .vertical
        pendingStack.alignment = .center
        pendingStack.spacing = 4
        pendingStack.backgroundColor = .white
        pendingStack.distribution = .fillEqually
        
        let deliveredStack = UIStackView(arrangedSubviews: [deliveredLabel, deliveredNumber])
        deliveredStack.axis = .vertical
        deliveredStack.alignment = .center
        deliveredStack.spacing = 4
        deliveredStack.backgroundColor = .white
        deliveredStack.distribution = .fillEqually
        
        let canceledStack = UIStackView(arrangedSubviews: [canceledLabel, canceledNumber])
        canceledStack.axis = .vertical
        canceledStack.alignment = .center
        canceledStack.spacing = 4
        canceledStack.backgroundColor = .white
        canceledStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [pendingStack, deliveredStack, canceledStack])
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
