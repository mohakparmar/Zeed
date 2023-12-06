//
//  CreateQuantityCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

protocol CreateQuantityCellDelegate: AnyObject {
    func didChangeQuantity(with quantity: Int)
}

class CreateQuantityCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CreateQuantityCellDelegate?
    
    var price: String? {
        didSet {
            guard let price = price else { return }
            quantityTextField.text = price
        }
    }
    
    //MARK: - UI Elements
    private lazy var quantityTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.addTarget(self, action: #selector(didChangeQuantity), for: .editingChanged)
        tf.keyboardType = .numberPad
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
    @objc func didChangeQuantity() {
        guard var text = quantityTextField.text else { return }
        if text.containsNonEnglishNumbers == false {
            text = text.english
        }
        guard let quantity = Int(text) else { return }
        delegate?.didChangeQuantity(with: quantity)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        contentView.addSubview(quantityTextField)
        quantityTextField.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: frame.width - frame.width/5))

        
        addSubview(seperatorView)
        seperatorView.anchor(left: quantityTextField.leftAnchor, bottom: quantityTextField.bottomAnchor, right: quantityTextField.rightAnchor, height: 1)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

extension String {
    var containsNonEnglishNumbers: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }

    var english: String {
        return self.applyingTransform(StringTransform.toLatin, reverse: false) ?? self
    }
}
