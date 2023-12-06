//
//  WalletTransferIBANCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/04/21.
//

import UIKit

protocol WalletTransferIBANCellDelegate: AnyObject {
    func didChangeIBAN(iban: String)
}

class WalletTransferIBANCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: WalletTransferIBANCellDelegate?
    
    //MARK: - UI Elements
    private lazy var ibanNumberTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = appDele!.isForArabic ? IBAN_Number_ar : IBAN_Number_en 
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
        guard let text = ibanNumberTextField.text else { return }
        delegate?.didChangeIBAN(iban: text)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        contentView.addSubview(ibanNumberTextField)
        ibanNumberTextField.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
        
        addSubview(seperatorView)
        seperatorView.anchor(left: ibanNumberTextField.leftAnchor, bottom: ibanNumberTextField.bottomAnchor, right: ibanNumberTextField.rightAnchor, height: 1)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

