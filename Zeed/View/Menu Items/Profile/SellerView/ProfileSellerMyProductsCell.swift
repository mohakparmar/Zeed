//
//  ProfileSellerMyProductsCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class ProfileSellerMyProductsCell: UITableViewCell {
    //MARK: - Properties
    var obj : SellerStatastics? {
        didSet {
            activeNumber.text = obj?.activePosts
            inactiveNumber.text = obj?.inactivePosts
        }
    }

    //MARK: - UI Elements
    private let activeLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Active_ar : Active_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let activeNumber: UILabel = {
        let label = UILabel()
        label.text = "200"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let inactiveLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Inactive_ar : Inactive_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let inactiveNumber: UILabel = {
        let label = UILabel()
        label.text = "200"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureUI() {
        backgroundColor = .white
        
        layer.cornerRadius = 20
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.appPrimaryColor.cgColor
        
        let activeStack = UIStackView(arrangedSubviews: [activeLabel, activeNumber])
        activeStack.axis = .vertical
        activeStack.alignment = .center
        activeStack.spacing = 4
        activeStack.backgroundColor = .white
        activeStack.distribution = .fillEqually
        
        let inactiveStack = UIStackView(arrangedSubviews: [inactiveLabel, inactiveNumber])
        inactiveStack.axis = .vertical
        inactiveStack.alignment = .center
        inactiveStack.spacing = 4
        inactiveStack.backgroundColor = .white
        inactiveStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [activeStack, inactiveStack])
        mainStack.alignment = .center
        mainStack.distribution = .fillEqually
        mainStack.spacing = 1
        mainStack.axis = .horizontal
        mainStack.backgroundColor = .appPrimaryColor
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
