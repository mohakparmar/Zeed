//
//  BecomeSellerBusinessTypeCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 13/09/21.
//

import UIKit

protocol BecomeSellerBusinessTypeCellDelegate: AnyObject {
    func didSelectStoreType(type: RegisterSellerType)
}

class BecomeSellerBusinessTypeCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: BecomeSellerBusinessTypeCellDelegate?
    
    var selectedStoreType: RegisterSellerType? {
        didSet {
            guard let selectedStoreType = selectedStoreType else { return }
            
            switch selectedStoreType {
            case .home:
                deselectAll()
                homeBasedButton.isSelected.toggle()
                
                if homeBasedButton.isSelected {
                    homeBasedButton.backgroundColor = .appPrimaryColor
                    homeBasedButton.layer.borderWidth = 0
                } else {
                    homeBasedButton.backgroundColor = .appBackgroundColor
                    homeBasedButton.layer.borderWidth = 0.5
                }

            case .store:
                deselectAll()
                storeBasedButton.isSelected.toggle()
                
                if storeBasedButton.isSelected {
                    storeBasedButton.backgroundColor = .appPrimaryColor
                    storeBasedButton.layer.borderWidth = 0
                } else {
                    storeBasedButton.backgroundColor = .appBackgroundColor
                    storeBasedButton.layer.borderWidth = 0.5
                }
            }
        }
    }
    
    //MARK: - UI Elements
    private lazy var homeBasedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(appDele!.isForArabic ? Home_Based_en : Home_Based_en, for: .normal)
        
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.backgroundColor = .appBackgroundColor
        button.layer.cornerRadius = 9
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.appPrimaryColor.cgColor
        
        button.addTarget(self, action: #selector(handleHomeBasedTapped), for: .touchUpInside)
        
        return button
    }()

    
    private lazy var storeBasedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(appDele!.isForArabic ? Store_ar : Store_en, for: .normal)
        
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.backgroundColor = .appBackgroundColor
        button.layer.cornerRadius = 9
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.appPrimaryColor.cgColor
        
        button.addTarget(self, action: #selector(handleStoreBasedTapped), for: .touchUpInside)
        
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
    @objc func handleHomeBasedTapped() {
        deselectAll()
        homeBasedButton.isSelected.toggle()
        
        if homeBasedButton.isSelected {
            homeBasedButton.backgroundColor = .appPrimaryColor
            homeBasedButton.layer.borderWidth = 0
        } else {
            homeBasedButton.backgroundColor = .appBackgroundColor
            homeBasedButton.layer.borderWidth = 0.5
        }
        
        delegate?.didSelectStoreType(type: .home)
    }
    
    
    @objc func handleStoreBasedTapped() {
        deselectAll()
        storeBasedButton.isSelected.toggle()
        
        if storeBasedButton.isSelected {
            storeBasedButton.backgroundColor = .appPrimaryColor
            storeBasedButton.layer.borderWidth = 0
        } else {
            storeBasedButton.backgroundColor = .appBackgroundColor
            storeBasedButton.layer.borderWidth = 0.5
        }
        
        delegate?.didSelectStoreType(type: .store)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        let buttonStack = UIStackView(arrangedSubviews: [homeBasedButton, storeBasedButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        
        contentView.addSubview(buttonStack)
        buttonStack.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 10, right: frame.width/3))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
    
    func deselectAll() {
        homeBasedButton.isSelected = false
        storeBasedButton.isSelected = false
        
        homeBasedButton.backgroundColor = .appBackgroundColor
        homeBasedButton.layer.borderWidth = 0.5
        
        
        storeBasedButton.backgroundColor = .appBackgroundColor
        storeBasedButton.layer.borderWidth = 0.5
    }
}
