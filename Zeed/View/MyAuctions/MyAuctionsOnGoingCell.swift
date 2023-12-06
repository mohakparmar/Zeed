//
//  MyAuctionsOnGoingCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/04/21.
//

import UIKit

class MyAuctionsOnGoingCell: UICollectionViewCell {
    //MARK: - Properties
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
    
    lazy var highestBidLabel: UILabel = {
        let label = UILabel()
        label.text = "Highest - 0.000 KWD"
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var timerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "timer_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .appPrimaryColor
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.setDimensions(height: 27, width: 27)
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "1 Days and 2 Hours"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .appPrimaryColor
        return label
    }()
    
    private lazy var statisticsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gradientSecondColor
        button.setTitle("Statistics", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setDimensions(height: 42, width: 130)
        
        button.addTarget(self, action: #selector(handleBidTapped), for: .touchUpInside)
        
        return button
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
        
        let timerStack = UIStackView(arrangedSubviews: [timerButton, timerLabel])
        timerStack.axis = .horizontal
        timerStack.alignment = .center
        timerStack.distribution = .fill
        timerStack.spacing = 4
        
        let infoStack = UIStackView(arrangedSubviews: [itemNameLabel, bidLabel, highestBidLabel, timerStack, statisticsButton])
        infoStack.axis = .vertical
        infoStack.alignment = .leading
        infoStack.spacing = 3
        infoStack.distribution = .fillProportionally
        infoStack.setCustomSpacing(8, after: timerStack)
        
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
