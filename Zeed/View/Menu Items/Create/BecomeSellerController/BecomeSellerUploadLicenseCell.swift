//
//  BecomeSellerUploadLicenseCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 13/09/21.
//

import UIKit

protocol BecomeSellerUploadLicenseCellDelegate: AnyObject {
    func didTapSelectImage()
    func didTapRemoveImage()
}

class BecomeSellerUploadLicenseCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: BecomeSellerUploadLicenseCellDelegate?
    
    var isImageSelected: Bool = false {
        didSet {
            if isImageSelected {
                uploadImageButton.setTitle(appDele!.isForArabic ? Change_ar : Change_en, for: .normal)
                removeButton.alpha = 1
            } else {
                uploadImageButton.setTitle(appDele!.isForArabic ? Upload_Images_ar : Upload_Images_en, for: .normal)
                removeButton.alpha = 0
            }
        }
    }
    //MARK: - UI Elements
    private lazy var uploadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Upload_Images_ar : Upload_Images_en , for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.addTarget(self, action: #selector(didTapSelectImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Remove_ar : Remove_en, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
        return button
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
    @objc func didTapSelectImage() {
        delegate?.didTapSelectImage()
    }
    
    @objc func didTapRemove() {
        delegate?.didTapRemoveImage()
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        let buttonStack = UIStackView(arrangedSubviews: [uploadImageButton, removeButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.spacing = 10
        buttonStack.distribution = .equalCentering
        
        contentView.addSubview(buttonStack)
        buttonStack.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 10, right: 12))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
