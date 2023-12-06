//
//  BecomeSellerTextFieldCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 13/09/21.
//

import UIKit

protocol BecomeSellerTextFieldCellDelegate: AnyObject {
    func didChangeText(text: String, onCellType cellType: BecomeSellerSections)
}

class BecomeSellerTextFieldCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: BecomeSellerTextFieldCellDelegate?
    
    var cellType: BecomeSellerSections? {
        didSet {
            guard let cellType = cellType else { return }
            textFeild.placeholder = "\(appDele!.isForArabic ? Enter_ar : Enter_en) \(cellType.description)"
        }
    }
    
    var text: String? {
        didSet {
            guard let text = text else { return }
            textFeild.text = text
        }
    }
    
    //MARK: - UI Elements
    lazy var textFeild: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        return tf
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func didChangeText() {
        guard let text = textFeild.text else { return }
        guard let cellType = cellType else { return }
        
        delegate?.didChangeText(text: text, onCellType: cellType)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        contentView.addSubview(textFeild)
        textFeild.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
        
        addSubview(seperatorView)
        seperatorView.anchor(left: textFeild.leftAnchor, bottom: textFeild.bottomAnchor, right: textFeild.rightAnchor, height: 1)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
