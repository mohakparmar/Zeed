//
//  AddressDetailsAddAddressCell.swift
//  Fortune
//
//  Created by Shrey Gupta on 29/12/20.
//

import UIKit

protocol AddressDetailsAddAddressCellDelegate: AnyObject {
    func didUpdateAddressLane1(with text: String)
    func didUpdateAddressLane2(with text: String)
    func didUpdateLandmark(with text: String)
    func didTapSelectCity()
    func didTapSelectLocation()
    func didChangeDirection(with text: String)
}

class AddressDetailsAddAddressCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: AddressDetailsAddAddressCellDelegate?
    
    var selectedAddressLane1: String? {
        didSet {
            guard let text = selectedAddressLane1 else { return }
            addressLine1TextField.text = text
        }
    }
    
    var selectedAddressLane2: String? {
        didSet {
            guard let text = selectedAddressLane2 else { return }
            addressLine2TextField.text = text
        }
    }
    
    var landmark: String? {
        didSet {
            guard let text = landmark else { return }
            landmarkTextFeild.text = text
        }
    }
    
    var selectedCoordinate: SellingLocation? {
        didSet {
            guard selectedCoordinate != nil else {
                selectLocationButton.isSelected = false
                return
            }
            selectLocationButton.isSelected = true
        }
    }
    
    var selectedCity: AddressCity? {
        didSet {
            guard let city = selectedCity else {
                selectCityButton.setTitle("Select City", for: .normal)
                return
            }
            selectCityButton.setTitle("\(city.name), \(city.state.name)", for: .normal)
        }
    }
    
    var selectedDesc: String? {
        didSet {
            guard let text = selectedDesc else { return }
            directionTextBox.text = text
            placeHolderLabel.text = ""
        }
    }

    
    //MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var addressLine1TextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "House No., Building Name"
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.placeholderFontScale = 1
        tf.anchor(height: 50)
        tf.addTarget(self, action: #selector(handleUpdateAddressLane1), for: .allEditingEvents)
        return tf
    }()
    
    private lazy var addressLine2TextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "Road Name, Area, Colony"
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.placeholderFontScale = 1
        tf.anchor(height: 50)
        tf.addTarget(self, action: #selector(handleUpdateAddressLane2), for: .allEditingEvents)
        return tf
    }()
    
    private lazy var landmarkTextFeild: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "Landmark (optional)"
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.placeholderFontScale = 1
        tf.anchor(height: 50)
        tf.addTarget(self, action: #selector(handleUpdateLandmark), for: .allEditingEvents)
        return tf
    }()
    
    private lazy var selectCityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Select City", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = .lightGray.withAlphaComponent(0.1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSelectCity), for: .touchUpInside)
        return button
    }()
    
    private lazy var selectLocationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Select Location", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("Change Location", for: .selected)
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = .lightGray.withAlphaComponent(0.1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSelectLocation), for: .touchUpInside)
        return button
    }()
    
    private lazy var directionTextBox: UITextView = {
        let tv = UITextView()
        
        tv.font = UIFont.systemFont(ofSize: 15)
        
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        
        return tv
    }()
    
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Enter Direction for Help (optional)"
        label.textAlignment = .left
        label.sizeToFit()
        label.isEnabled = false
        label.isUserInteractionEnabled = false
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        directionTextBox.delegate = self
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleSelectCity() {
        delegate?.didTapSelectCity()
    }
    
    @objc func handleSelectLocation() {
        delegate?.didTapSelectLocation()
    }
    
    @objc func handleUpdateAddressLane1() {
        guard let text = addressLine1TextField.text else { return }
        delegate?.didUpdateAddressLane1(with: text)
    }
    
    @objc func handleUpdateAddressLane2() {
        guard let text = addressLine2TextField.text else { return }
        delegate?.didUpdateAddressLane2(with: text)
    }
    
    @objc func handleUpdateLandmark() {
        guard let text = landmarkTextFeild.text else { return }
        delegate?.didUpdateLandmark(with: text)
    }
    //MARK: - Helper Function
    
    func configureCell() {
        backgroundColor = .white
        addShadow()
        
        directionTextBox.anchor(height: 100)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
    
        let selectButtonStack = UIStackView(arrangedSubviews: [selectCityButton, selectLocationButton])
        selectButtonStack.axis = .horizontal
        selectButtonStack.alignment = .fill
        selectButtonStack.spacing = 10
        selectButtonStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [addressLine1TextField, addressLine2TextField, landmarkTextFeild, selectButtonStack])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually
        mainStack.spacing = 8
        
        let finalMainStack = UIStackView(arrangedSubviews: [mainStack, directionTextBox])
        finalMainStack.axis = .vertical
        finalMainStack.alignment = .fill
        finalMainStack.distribution = .fillProportionally
        finalMainStack.spacing = 8
        
        addSubview(finalMainStack)
        finalMainStack.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 10, paddingBottom: 20, paddingRight: 10)
    
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: directionTextBox.topAnchor, left: directionTextBox.leftAnchor, right: directionTextBox.rightAnchor, paddingTop: 8, paddingLeft: 6, paddingRight: 6)
    }
}


//MARK: - Delegate UITextViewDelegate

extension AddressDetailsAddAddressCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty == false {
            placeHolderLabel.text = ""
        } else {
            placeHolderLabel.text = "Enter Direction for help(Optional)"
        }
        
        delegate?.didChangeDirection(with: textView.text)
    }
}
