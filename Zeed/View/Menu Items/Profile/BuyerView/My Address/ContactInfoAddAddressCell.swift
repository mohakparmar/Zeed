//
//  ContactInfoAddAddress.swift
//  Fortune
//
//  Created by Shrey Gupta on 29/12/20.
//

import UIKit

protocol ContactInfoAddAddressCellDelegate: AnyObject {
    func didUpdateAddressName(withText text: String)
    func didUpdateMobileNo(withNo num: String)
    func didUpdateAlternateMobileNo(withNo num: String)
}

class ContactInfoAddAddressCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: ContactInfoAddAddressCellDelegate?
    
    var addressName: String? {
        didSet {
            guard let text = addressName else { return }
            nameTextFeild.text = text
        }
    }
    
    var mobileNo: String? {
        didSet {
            guard let text = mobileNo else { return }
            mobileTextFeild.text = text
        }
    }
    
    var alternateMobileNo: String? {
        didSet {
            guard let text = alternateMobileNo else { return }
            alternateMobileTextFeild.text = text
        }
    }
    
    
    
    //MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var nameTextFeild: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "Address Name"
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.placeholderFontScale = 1
        tf.anchor(height: 50)
        tf.addTarget(self, action: #selector(didUpdateName), for: .allEditingEvents)
        return tf
    }()
    
    private lazy var mobileTextFeild: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "Mobile No."
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.placeholderFontScale = 1
        tf.anchor(height: 50)
        tf.keyboardType = .phonePad
        tf.addTarget(self, action: #selector(didUpdateMobileNo), for: .allEditingEvents)
        return tf
    }()
    
    private lazy var alternateMobileTextFeild: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "Alternate Mobile No."
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.placeholderFontScale = 1
        tf.anchor(height: 50)
        tf.keyboardType = .phonePad
        tf.addTarget(self, action: #selector(didUpdateAlternateMobileNo), for: .allEditingEvents)
        return tf
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
    @objc func didUpdateName() {
        guard let text = nameTextFeild.text else { return }
        delegate?.didUpdateAddressName(withText: text)
    }
    
    @objc func didUpdateMobileNo() {
        guard let mobile = mobileTextFeild.text  else { return }
        delegate?.didUpdateMobileNo(withNo: mobile)
    }
    
    @objc func didUpdateAlternateMobileNo() {
        guard let mobile = alternateMobileTextFeild.text else { return }
        delegate?.didUpdateAlternateMobileNo(withNo: mobile)
    }
    
    //MARK: - Helper Function
    
    func configureCell() {
        backgroundColor = .white
        addShadow()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        let stack = UIStackView(arrangedSubviews: [nameTextFeild, mobileTextFeild, alternateMobileTextFeild])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        
        addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 10, paddingBottom: 20, paddingRight: 10)
    }
}
