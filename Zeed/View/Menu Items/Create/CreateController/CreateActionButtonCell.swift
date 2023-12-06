//
//  CreateActionButtonCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

protocol CreateActionButtonCellDelegate: AnyObject {
    func didTapAddVarient()
    func didTapContinue()
}
class CreateActionButtonCell: UITableViewCell {
    //MARK: - Properties
    var isVariantEnabled = true {
        didSet {
            addVarientButton.isEnabled = isVariantEnabled
        }
    }
    
    weak var delegate: CreateActionButtonCellDelegate?
    
    //MARK: - UI Elements
    private lazy var addVarientButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Add_Variants_ar : Add_Variants_en, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 9
        
        button.addTarget(self, action: #selector(handleAddVarient), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Continue_ar : Continue_en, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 9
        
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
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
    @objc func handleAddVarient() {
        delegate?.didTapAddVarient()
    }
    
    @objc func handleContinue() {
        delegate?.didTapContinue()
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        let buttonStack = UIStackView(arrangedSubviews: [addVarientButton, continueButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        
        contentView.addSubview(buttonStack)
        buttonStack.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 10, right: 12))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

