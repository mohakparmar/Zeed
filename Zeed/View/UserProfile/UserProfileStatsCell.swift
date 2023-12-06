//
//  UserProfileStatsCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit

class UserProfileStatsCell: UICollectionViewCell {
    //MARK: - Properties
    var user: User?
    
    var type: UserProfileStatsCellTypes? {
        didSet {
            guard let user = user else { return }
            guard let type = type else { return }
            statsLabel.text = type.description
            
            switch type {
            case .followers:
                statsNumberLabel.text = String(user.followers)
            case .following:
                statsNumberLabel.text = String(user.following)
            case .products:
                statsNumberLabel.text = String(user.numberOfProducts)
            case .auctions:
                statsNumberLabel.text = String(user.numberOfAuctions)
            }
        }
    }
    
    //MARK: - UI Elements
    let statsNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let statsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        backgroundColor = .appBackgroundColor
        
        let mainStack = UIStackView(arrangedSubviews: [statsNumberLabel, statsLabel])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        
        addSubview(mainStack)
        mainStack.centerX(inView: self)
        mainStack.centerY(inView: self)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

