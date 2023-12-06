//
//  CreatePriceCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

protocol CreatePriceCellDelegate: AnyObject {
    func didChangePrice(with price: Double)
}

class CreatePriceCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CreatePriceCellDelegate?
    var price: String? {
        didSet {
            guard let price = price else { return }
            priceTextField.text = price
        }
    }
    
    //MARK: - UI Elements
    private lazy var priceTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.addTarget(self, action: #selector(didChangePrice), for: .editingChanged)
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    private let priceCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? KWD_ar : KWD_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
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
    @objc func didChangePrice() {
        guard var text = priceTextField.text else { return }
        if text.containsNonEnglishNumbers == false {
            text = text.english
        }
        guard let price = Double(text) else { return }
        delegate?.didChangePrice(with: price)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        contentView.addSubview(priceTextField)
        priceTextField.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: frame.width - frame.width/5))
        
        contentView.addSubview(priceCurrencyLabel)
        priceCurrencyLabel.anchor(left: priceTextField.rightAnchor, paddingLeft: 15)
        priceCurrencyLabel.centerY(inView: priceTextField)
        
        addSubview(seperatorView)
        seperatorView.anchor(left: priceTextField.leftAnchor, bottom: priceTextField.bottomAnchor, right: priceTextField.rightAnchor, height: 1)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

