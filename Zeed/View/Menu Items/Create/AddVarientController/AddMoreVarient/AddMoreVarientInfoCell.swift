//
//  AddMoreVarientInfoCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 27/04/21.
//

import UIKit

protocol AddMoreVarientInfoCellDelegate: AnyObject {
    func didChangeVarientValue(varientValue: String, fromCell cell: AddMoreVarientInfoCell)
}

class AddMoreVarientInfoCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: AddMoreVarientInfoCellDelegate?
    
    var indexPath: IndexPath?
    
    var editVariant: CreateItemVariant? {
        didSet {
            guard let varient = editVariant else { return }
            guard let index = indexPath else { return }
//            valueTextField.text = varient.attributes[index.section]
        }
    }
    
    
    //MARK: - UI Elements

    private lazy var valueTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Value"
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.addTarget(self, action: #selector(didChangeVarientValue), for: .editingChanged)
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
    @objc func didChangeVarientValue() {
        guard let text = valueTextField.text else { return }
        delegate?.didChangeVarientValue(varientValue: text, fromCell: self)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .appBackgroundColor
        selectionStyle = .none
        
        let varientSeperatorView = UIView()
        varientSeperatorView.backgroundColor = .lightGray
        
        let valueSeperatorView = UIView()
        valueSeperatorView.backgroundColor = .lightGray
        
        let varientInfoStack = UIStackView(arrangedSubviews: [valueTextField])
        varientInfoStack.alignment = .fill
        varientInfoStack.distribution = .fillEqually
        varientInfoStack.spacing = 15

        contentView.addSubview(varientInfoStack)
        varientInfoStack.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
        
        
        addSubview(valueSeperatorView)
        valueSeperatorView.anchor(left: valueTextField.leftAnchor, bottom: valueTextField.bottomAnchor, right: valueTextField.rightAnchor, height: 1)
    }
}

