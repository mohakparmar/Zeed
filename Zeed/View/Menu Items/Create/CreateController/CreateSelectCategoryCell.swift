//
//  CreateSelectCategoryCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

class CreateSelectCategoryCell: UITableViewCell {
    //MARK: - Properties
    var itemCategory: ItemCategory? {
        didSet {
            guard let category = itemCategory else { return }
            categoryTitleLabel.text = appDele!.isForArabic ? category.name_ar : category.name
        }
    }
    
    //MARK: - UI Elements
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Select_Category_ar : Select_Category_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
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
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        addSubview(categoryTitleLabel)
        categoryTitleLabel.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
        
        addSubview(seperatorView)
        seperatorView.anchor(left: categoryTitleLabel.leftAnchor, bottom: categoryTitleLabel.bottomAnchor, right: categoryTitleLabel.rightAnchor, height: 1)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
