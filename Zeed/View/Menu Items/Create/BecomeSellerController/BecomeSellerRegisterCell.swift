//
//  BecomeSellerRegisterCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 13/09/21.
//

import UIKit

protocol BecomeSellerRegisterCellDelegate: AnyObject {
    func didTapRegister()
}
class BecomeSellerRegisterCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: BecomeSellerRegisterCellDelegate?
    
    //MARK: - UI Elements
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Continue_ar : Continue_en, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 9
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
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
    @objc func handleRegister() {
        delegate?.didTapRegister()
    }
    
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        let buttonStack = UIStackView(arrangedSubviews: [registerButton])
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

