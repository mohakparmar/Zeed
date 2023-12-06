//
//  WalletTransferAmountCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/04/21.
//

import UIKit

protocol WalletTransferAmountCellDelegate: AnyObject {
    func didChangeAmount(amount: Double)
}

class WalletTransferAmountCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: WalletTransferAmountCellDelegate?
    var amount : String? {
        didSet {
            self.amountLabel.text = amount
        }
    }
    
    //MARK: - UI Elements
    private lazy var amountLabel: UITextField = {
        let tf = UITextField()
        tf.placeholder = appDele!.isForArabic ? Amount_ar : Amount_en 
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
        guard let text = amountLabel.text else { return }
        delegate?.didChangeAmount(amount: Double(text) ?? 0)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        contentView.addSubview(amountLabel)
        amountLabel.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
        
        addSubview(seperatorView)
        seperatorView.anchor(left: amountLabel.leftAnchor, bottom: amountLabel.bottomAnchor, right: amountLabel.rightAnchor, height: 1)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}


