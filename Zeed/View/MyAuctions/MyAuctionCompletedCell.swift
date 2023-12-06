//
//  MyAuctionCompletedCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/04/21.
//

import Foundation
import UIKit

class MyAuctionCompletedCell: UICollectionViewCell {
    private let itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .random
        return iv
    }()
    
    lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = "iPhone 12 Pro 256GB"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var bidLabel: UILabel = {
        let label = UILabel()
        label.text = "Bid - 0.000 KWD"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var buyerLabel: UILabel = {
        let label = UILabel()
        label.text = "Buyer - ms94d"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc func handleBidTapped() {
        
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = 12
        clipsToBounds = true
        addShadow()
        
        let infoStack = UIStackView(arrangedSubviews: [itemNameLabel, buyerLabel, bidLabel])
        infoStack.axis = .vertical
        infoStack.alignment = .leading
        infoStack.spacing = 3
        infoStack.distribution = .fillProportionally
        
        itemImageView.setDimensions(height: frame.height - 20, width: frame.height * 0.75)

        let mainStack = UIStackView(arrangedSubviews: [itemImageView, infoStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 8
        mainStack.distribution = .fillProportionally
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}
