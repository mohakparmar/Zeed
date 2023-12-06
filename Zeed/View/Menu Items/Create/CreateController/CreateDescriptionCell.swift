//
//  CreateDetailCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

protocol CreateDescriptionDelegate: AnyObject {
    func didChangeDescription(with text: String, isEnglish: Bool)
}

class CreateDescriptionCell: UITableViewCell {
    //MARK: - Properties
    
    weak var delegate: CreateDescriptionDelegate?
    var isEng : Bool = true
    //MARK: - UI Elements
    
    var desc : String? {
        didSet {
            descriptionTextBox.text = desc
            placeHolderLabel.text = ""
        }
    }
    
    private lazy var descriptionTextBox: UITextView = {
        let tv = UITextView()
        
        tv.font = UIFont.systemFont(ofSize: 15, weight: .light)
        
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        
        return tv
    }()
    
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.text = appDele!.isForArabic ? Enter_productad_description_ar : Enter_productad_description_en
        label.textAlignment = .left
        label.sizeToFit()
        label.isEnabled = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
        
        descriptionTextBox.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Selectors
    
    
    //MARK: - Helper Functions
    
    func configureUI() {
        backgroundColor = .appBackgroundColor
        
        contentView.addSubview(descriptionTextBox)
        descriptionTextBox.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: descriptionTextBox.topAnchor, left: descriptionTextBox.leftAnchor, right: descriptionTextBox.rightAnchor, paddingTop: 8, paddingLeft: 6, paddingRight: 6)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

//MARK: - Delegate UITextViewDelegate

extension CreateDescriptionCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty == false {
            placeHolderLabel.text = ""
        } else {
            placeHolderLabel.text = appDele!.isForArabic ? Enter_productad_description_ar : Enter_productad_description_en
        }
        
        delegate?.didChangeDescription(with: textView.text, isEnglish: isEng)
    }
}

