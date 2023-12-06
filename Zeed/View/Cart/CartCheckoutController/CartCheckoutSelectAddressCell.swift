//
//  CartCheckoutSelectAddressCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 11/12/21.
//

import UIKit

class CartCheckoutSelectAddressCell: UICollectionViewCell {
    //MARK: - Properties
    var address: Address? {
        didSet {
            guard let address = address else { return }
            
            nameLabel.text = address.name
            addressTypeLabel.text = address.addressType.rawValue
            addressLabel.text = address.getAddressString()
            mobileLabel.text = "\(appDele!.isForArabic ? Mobile_Number_ar : Mobile_Number_en): \(address.mobileNumber)"
        }
    }
    
    
    //MARK: - UI Elements
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let addressTypeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .appPrimaryColor
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        
        label.setDimensions(height: 20, width: 50)
        label.layer.cornerRadius = 20/2
        label.clipsToBounds = true
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 3
        return label
    }()
    
    private let mobileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
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
        layer.cornerRadius = 5
        addShadow()
        
        let nameTypeStack = UIStackView(arrangedSubviews: [nameLabel, addressTypeLabel])
        nameTypeStack.axis = .horizontal
        nameTypeStack.alignment = .center
        nameTypeStack.distribution = .fill
        nameTypeStack.spacing = 8
        
        
        let nameTypeButtonsStack = UIStackView(arrangedSubviews: [nameTypeStack, UIView()])
        nameTypeButtonsStack.axis = .horizontal
        nameTypeButtonsStack.alignment = .center
        nameTypeButtonsStack.distribution = .equalSpacing
        nameTypeButtonsStack.spacing = 25
        
        
        let mainStack = UIStackView(arrangedSubviews: [nameTypeButtonsStack, addressLabel, mobileLabel])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .equalSpacing
        
        addSubview(mainStack)
        mainStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 10, paddingRight: 5)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
