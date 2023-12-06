//
//  WalletTransferConfirmCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/04/21.
//

import UIKit

protocol WalletTransferConfirmCellDelegate: class {
    func didTapContinue()
}

class WalletTransferConfirmCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: WalletTransferConfirmCellDelegate?
    
    //MARK: - UI Elements
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(appDele!.isForArabic ? Continue_ar : Continue_en, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
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
    
    @objc func handleContinue() {
        delegate?.didTapContinue()
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        contentView.addSubview(continueButton)
        continueButton.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
