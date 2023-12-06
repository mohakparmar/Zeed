//
//  ProfileSellerEarningCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class ProfileSellerEarningCell: UITableViewCell {
    
    var obj : SellerStatastics? {
        didSet {

        }
    }

    
    //MARK: - Properties
    private let transferredLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Transferred_ar : Transferred_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let transferredNumber: UILabel = {
        let label = UILabel()
        label.text = "0 \(appDele!.isForArabic ? KWD_ar : KWD_en)"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    //MARK: - UI Elements
    
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
        
        let transferredStack = UIStackView(arrangedSubviews: [transferredLabel, transferredNumber])
        transferredStack.axis = .vertical
        transferredStack.alignment = .center
        transferredStack.spacing = 4
        transferredStack.backgroundColor = .white
        transferredStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [transferredStack])
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
