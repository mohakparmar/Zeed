//
//  CategoryPickerCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

class CategoryPickerCell: UICollectionViewCell {
    //MARK: - Properties
    var category: ItemCategory! {
        didSet {
            titleLabel.text = appDele!.isForArabic ? category.name_ar : category.name
        }
    }
    
    //MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let bulletView: UIView = {
        let view = UIView()
        view.setDimensions(height: 15, width: 15)
        view.layer.cornerRadius = 15/2
        
        view.backgroundColor = .appPrimaryColor
                
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    
    
    //MARK: - Helper Function
    func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = 5
        
        addSubview(bulletView)
        bulletView.anchor(left: leftAnchor, paddingLeft: 8)
        bulletView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        
        let mainStack = UIStackView(arrangedSubviews: [bulletView, stack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .fill
        mainStack.spacing = 10
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }
    }
}


