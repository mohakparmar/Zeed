//
//  FeedExpandedVarientCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 17/04/21.
//

import UIKit

class FeedExpandedVarientCell : UICollectionViewCell {
    //MARK: - Properties
    let title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .appPrimaryColor
                title.textColor = .white
            } else {
                self.backgroundColor = .backgroundWhiteColor
                title.textColor = .black
            }
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .backgroundWhiteColor
        layer.cornerRadius = 4
        
        contentView.addSubview(title)
        title.fillSuperview(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}
