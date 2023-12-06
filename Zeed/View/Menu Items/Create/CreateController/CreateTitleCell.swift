//
//  CreateTitleCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

protocol CreateTitleCellDelegate: AnyObject {
    func didChangeTitle(title: String, isEng : Bool)
}

class CreateTitleCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CreateTitleCellDelegate?
    var isEnglish : Bool = true
    
    var title: String? {
        didSet {
            guard let title = title else { return }
            titleLabel.text = title
        }
    }
    
    //MARK: - UI Elements
    private lazy var titleLabel: UITextField = {
        let tf = UITextField()
        tf.placeholder = appDele!.isForArabic ? Try_to_keep_it_short_and_useful_ar : Try_to_keep_it_short_and_useful_en 
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
        guard let text = titleLabel.text else { return }
        delegate?.didChangeTitle(title: text, isEng: isEnglish)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        contentView.addSubview(titleLabel)
        titleLabel.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
        
        addSubview(seperatorView)
        seperatorView.anchor(left: titleLabel.leftAnchor, bottom: titleLabel.bottomAnchor, right: titleLabel.rightAnchor, height: 1)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
