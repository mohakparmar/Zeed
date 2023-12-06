//
//  TypeOfAddressAddAddressCell.swift
//  Fortune
//
//  Created by Shrey Gupta on 29/12/20.
//

import UIKit

protocol TypeOfAddressAddAddressCellDelegate: AnyObject {
    func didSelectTypeOfAdress(type: AddressType)
}

class TypeOfAddressAddAddressCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: TypeOfAddressAddAddressCellDelegate?
    
    var typeOfAddress: AddressType? {
        didSet {
            guard let type = typeOfAddress else { return }
            switch type {
            case .home:
                handleHomeTapped()
            case .work:
                handleWorkTapped()
            case .other:
                handleOtherTapped()
            }
        }
    }
    
    //MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Home", for: .normal)
        
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.addTarget(self, action: #selector(handleHomeTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var workButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Work", for: .normal)
        
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.addTarget(self, action: #selector(handleWorkTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var otherButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Other", for: .normal)
        
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.addTarget(self, action: #selector(handleOtherTapped), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        handleHomeTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleHomeTapped() {
        deselectAll()
        homeButton.isSelected.toggle()
        
        if homeButton.isSelected {
            homeButton.backgroundColor = .appPrimaryColor
            homeButton.layer.borderWidth = 0
        } else {
            homeButton.backgroundColor = .white
            homeButton.layer.borderWidth = 0.5
        }
        
        delegate?.didSelectTypeOfAdress(type: .home)
    }
    
    @objc func handleWorkTapped() {
        deselectAll()
        workButton.isSelected.toggle()
        
        if workButton.isSelected {
            workButton.backgroundColor = .appPrimaryColor
            workButton.layer.borderWidth = 0
        } else {
            workButton.backgroundColor = .white
            workButton.layer.borderWidth = 0.5
        }
        
        delegate?.didSelectTypeOfAdress(type: .work)
    }
    
    @objc func handleOtherTapped() {
        deselectAll()
        otherButton.isSelected.toggle()
        
        if otherButton.isSelected {
            otherButton.backgroundColor = .appPrimaryColor
            otherButton.layer.borderWidth = 0
        } else {
            otherButton.backgroundColor = .white
            otherButton.layer.borderWidth = 0.5
        }
        
        delegate?.didSelectTypeOfAdress(type: .other)
    }
    
    //MARK: - Helper Function
    
    func deselectAll() {
        homeButton.isSelected = false
        workButton.isSelected = false
        otherButton.isSelected = false
        
        homeButton.backgroundColor = .white
        homeButton.layer.borderWidth = 0.5
        
        workButton.backgroundColor = .white
        workButton.layer.borderWidth = 0.5
        
        otherButton.backgroundColor = .white
        otherButton.layer.borderWidth = 0.5
    }
    
    func configureCell() {
        backgroundColor = .white
        addShadow()
        
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        let buttonStack = UIStackView(arrangedSubviews: [homeButton, workButton, otherButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 18, paddingRight: 18, height: 45)
        buttonStack.centerX(inView: self)
        buttonStack.centerY(inView: self)
    }
}
