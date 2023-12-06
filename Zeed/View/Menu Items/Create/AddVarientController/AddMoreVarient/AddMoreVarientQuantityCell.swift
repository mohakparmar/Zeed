//
//  AddMoreVarientQuantityCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit

protocol AddMoreVarientQuantityCellDelegate: AnyObject {
    func didChangeQuantity(quantity: Int)
}

class AddMoreVarientQuantityCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: AddMoreVarientQuantityCellDelegate?
    
    var editVariant: CreateItemVariant? {
        didSet {
            guard let varient = editVariant else { return }
//            quantityTextField.text = String(varient.quantity)
        }
    }
    //MARK: - UI Elements
    private lazy var quantityTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.addTarget(self, action: #selector(didChangeQuantity), for: .editingChanged)
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
        guard let text = quantityTextField.text else { return }
        guard let quantity = Int(text) else { return }
        delegate?.didChangeQuantity(quantity: quantity)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .appBackgroundColor
        selectionStyle = .none
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        contentView.addSubview(quantityTextField)
        quantityTextField.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: frame.width - frame.width/5))

        
        addSubview(seperatorView)
        seperatorView.anchor(left: quantityTextField.leftAnchor, bottom: quantityTextField.bottomAnchor, right: quantityTextField.rightAnchor, height: 1)
    }
}
