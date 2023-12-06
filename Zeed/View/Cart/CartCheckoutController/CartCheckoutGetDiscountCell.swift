//
//  CartCheckoutGetDiscountCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 08/04/21.
//
import UIKit

protocol CartCheckoutGetDiscountCellDelegate: AnyObject {
    func handleVerifyTapped(forCode couponCode: String)
}

class CartCheckoutGetDiscountCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CartCheckoutGetDiscountCellDelegate?
    
    var couponCode: String? {
        didSet {
            guard let couponCode = couponCode else { return }
            couponTextField.text = couponCode
        }
    }
    
    //MARK: - UI Elements
    private let couponTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = appDele!.isForArabic ? Please_enter_coupon_code_ar : "Enter Coupon Code"
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Confirm_ar : "VERIFY", for: .normal)
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(handleVerifyTapped), for: .touchUpInside)
        return button
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
    @objc func handleVerifyTapped() {
        guard let couponText = couponTextField.text else { return }
        delegate?.handleVerifyTapped(forCode: couponText)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        verifyButton.anchor(width: 70)
        
        let mainStack = UIStackView(arrangedSubviews: [couponTextField, verifyButton])
        mainStack.alignment = .fill
        mainStack.axis = .horizontal
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 5
        contentView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
        
        addSubview(seperatorView)
        seperatorView.anchor(left: mainStack.leftAnchor, bottom: mainStack.bottomAnchor, right: mainStack.rightAnchor, height: 1)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
