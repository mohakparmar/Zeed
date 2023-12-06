//
//  MyOrderDetailAddressCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/04/21.
//

import UIKit

class MyOrderDetailAddressCell: UICollectionViewCell {
    //MARK: - Properties
    var orderItem: OrderItem? {
        didSet {
            guard let orderItem = orderItem else { return }
            nameLabel.text = orderItem.addressDetails.name
            addressLabel.text = orderItem.addressDetails.getAddressString()
            mobileLabel.text = "\(appDele!.isForArabic ? Mobile_Number_ar : Mobile_Number_en): +91 \(orderItem.addressDetails.mobileNumber)"
        }
    }
    
    //MARK: - UI Elements
    
    private let deliveryAddressLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Address_ar : Address_en
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.85)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.85)
        label.numberOfLines = 3
        return label
    }()
    
    private let mobileLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray.withAlphaComponent(0.85)
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 3
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helper Functions
    
    func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = 10
        addShadow()
        
        addSubview(deliveryAddressLabel)
        deliveryAddressLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 10, paddingRight: 10)
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, addressLabel, mobileLabel])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        stack.distribution = .equalCentering
        
        addSubview(stack)
        stack.anchor(top: deliveryAddressLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
