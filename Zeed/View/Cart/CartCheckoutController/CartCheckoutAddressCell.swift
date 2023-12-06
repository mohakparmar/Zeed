//
//  CartCheckoutAddressCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 07/04/21.
//

import UIKit

protocol CartCheckoutAddressCellDelegate: AnyObject {
    func didTapChangeAddress()
}

class CartCheckoutAddressCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CartCheckoutAddressCellDelegate?
    
    var address: Address? {
        didSet {
            changeButton.setTitle(appDele!.isForArabic ? Add_Address_ar : Add_Address_en, for: .normal)
            guard let address = address else { return }
            addressTypeLabel.text = address.name
            addressType.text = address.addressType.rawValue
            addressLabel.text = address.getAddressString()
            changeButton.setTitle(appDele!.isForArabic ? Change_ar : Change_en, for: .normal)
            mobileNumberLabel.text = String(format: "%@ : %@", appDele!.isForArabic ? Mobile_Number_ar : Mobile_Number_en, address.mobileNumber)
        }
    }
    
    private let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.addShadow()
        return view
    }()
    
    private let addressTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let addressType: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .appColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()

    
    private let mobileNumberLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    
    private lazy var changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.tintColor = .appPrimaryColor
        button.addTarget(self, action: #selector(handleChangeAddress), for: .touchUpInside)
        return button
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Your_address_list_is_emptyPlease_add_your_address_ar : Your_address_list_is_emptyPlease_add_your_address_en
        label.textColor = UIColor.darkGray.withAlphaComponent(0.8)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleChangeAddress() {
        delegate?.didTapChangeAddress()
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .appBackgroundColor
        
        contentView.addSubview(whiteView)
        whiteView.fillSuperview(padding: UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15))
        

        let addressStack = UIStackView(arrangedSubviews: [addressTypeLabel])
//        let addressStack = UIStackView(arrangedSubviews: [addressTypeLabel, addressType])
        addressStack.alignment = .leading
        addressStack.spacing = 8
        addressStack.distribution = .equalCentering

        let addressDetailStack = UIStackView(arrangedSubviews: [addressStack, changeButton])
        addressDetailStack.alignment = .center
        addressDetailStack.distribution = .equalCentering
        
        let mainStack = UIStackView(arrangedSubviews: [addressDetailStack, addressLabel, mobileNumberLabel])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fillProportionally
        
        whiteView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
