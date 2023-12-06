//
//  CartCheckoutHideMyPurchasesCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 08/04/21.
//

import UIKit

class CartCheckoutHideMyPurchasesCell: UITableViewCell {
    //MARK: - Properties
    
    //MARK: - UI Elements
    private let hideMyPurchaseLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Hide_my_Purchase_ar : Hide_my_Purchase_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    
    lazy var imgCheck: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "uncheck")
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(height: 20, width: 20)
        return iv
    }()

    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imgCheck.image = #imageLiteral(resourceName: "check1")
            } else {
                imgCheck.image = #imageLiteral(resourceName: "uncheck")
            }
        }
    }
    
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
        
        let mainStack = UIStackView(arrangedSubviews: [hideMyPurchaseLabel, imgCheck])
        mainStack.alignment = .fill
        mainStack.axis = .horizontal
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 5
        contentView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 20))

        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

//        addSubview(hideMyPurchaseLabel)
//        addSubview(imgCheck)
//
//        hideMyPurchaseLabel.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
//        imgCheck.frame = CGRect(x: 100, y: 5, width: 30, height: 30)
        
    }
}
