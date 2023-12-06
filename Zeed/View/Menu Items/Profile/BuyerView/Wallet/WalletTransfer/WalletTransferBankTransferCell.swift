//
//  WalletTransferBankTransferCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/04/21.
//

import UIKit

protocol WalletTransferBankTransferCellDelegate: AnyObject {
    func didChangeBankName(name: String)
}

class WalletTransferBankTransferCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: WalletTransferBankTransferCellDelegate?
    
    //MARK: - UI Elements
    private lazy var bankNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = appDele!.isForArabic ? Bank_Name_ar : Bank_Name_en 
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.addTarget(self, action: #selector(didChangeTitle), for: .editingChanged)
        return tf
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
    
    @objc func didChangeTitle() {
        guard let text = bankNameTextField.text else { return }
        delegate?.didChangeBankName(name: text)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        contentView.addSubview(bankNameTextField)
        bankNameTextField.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
        
        addSubview(seperatorView)
        seperatorView.anchor(left: bankNameTextField.leftAnchor, bottom: bankNameTextField.bottomAnchor, right: bankNameTextField.rightAnchor, height: 1)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
