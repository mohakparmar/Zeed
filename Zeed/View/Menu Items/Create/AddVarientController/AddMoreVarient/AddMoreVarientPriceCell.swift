//
//  AddMoreVarientPriceCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit

protocol AddMoreVarientPriceCellDelegate: AnyObject {
    func didChangePrice(price: Double)
}

class AddMoreVarientPriceCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: AddMoreVarientPriceCellDelegate?
    
    var editVariant: CreateItemVariant? {
        didSet {
            guard let varient = editVariant else { return }
//            priceTextField.text = String(varient.price)
        }
    }
    
    //MARK: - UI Elements
    private lazy var priceTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(didChangePrice), for: .editingChanged)
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private let priceCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = "KWD"
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
        guard let text = priceTextField.text else { return }
        guard let price = Double(text) else { return }
        delegate?.didChangePrice(price: price)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .appBackgroundColor
        selectionStyle = .none
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        contentView.addSubview(priceTextField)
        priceTextField.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: frame.width - frame.width/5))
        
        contentView.addSubview(priceCurrencyLabel)
        priceCurrencyLabel.anchor(left: priceTextField.rightAnchor, paddingLeft: 15)
        priceCurrencyLabel.centerY(inView: priceTextField)
        
        addSubview(seperatorView)
        seperatorView.anchor(left: priceTextField.leftAnchor, bottom: priceTextField.bottomAnchor, right: priceTextField.rightAnchor, height: 1)
    }
}
