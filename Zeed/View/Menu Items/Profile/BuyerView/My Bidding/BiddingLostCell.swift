//
//  BiddingLostCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class BiddingLostCell: UICollectionViewCell {
    //MARK: - Properties
    var myBidding: MyBiddingItem? {
        didSet {
            guard let myBidding = myBidding else { return }
            itemImageView.loadImage(from: myBidding.medias.first?.url ?? "")
            itemNameLabel.text = appDele!.isForArabic ?  myBidding.title : myBidding.title_ar
//            bidLabel.text = "\(appDele!.isForArabic ? Bid_ar : Bid_en) - \(myBidding.myBid.price) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
//            highestBidLabel.text = "\(appDele!.isForArabic ? Highest_ar : Highest_en) - \(myBidding.currentBid?.price ?? 0) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            
            bidLabel.text = String(format: "%@ - %.3f %@", appDele!.isForArabic ? Bid_ar : Bid_en, myBidding.myBid.price, appDele!.isForArabic ? KWD_ar : KWD_en)
            highestBidLabel.text = String(format: "%@ - %.3f %@", appDele!.isForArabic ? Highest_ar : Highest_en, myBidding.currentBid?.price ?? 0, appDele!.isForArabic ? KWD_ar : KWD_en)

            
            refundStatusLabel.text = myBidding.displayStatus
        }
    }

    //MARK: - UI Elements
    private let itemImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .random
        return iv
    }()
    
    lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var bidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var highestBidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var refundStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.8)
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
        
        let infoStack = UIStackView(arrangedSubviews: [itemNameLabel, bidLabel, highestBidLabel, refundStatusLabel])
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
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
