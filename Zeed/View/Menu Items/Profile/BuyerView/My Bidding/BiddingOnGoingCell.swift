//
//  BiddingOnGoingCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class BiddingOnGoingCell: UICollectionViewCell {
    //MARK: - Properties
    var myBidding: MyBiddingItem? {
        didSet {
            guard let myBidding = myBidding else { return }
            itemImageView.loadImage(from: myBidding.medias.first?.url ?? "")
            itemNameLabel.text = myBidding.title
//            bidLabel.text = "\(appDele!.isForArabic ? Bid_ar : Bid_en) - \(myBidding.myBid.price) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
//            highestBidLabel.text = "\(appDele!.isForArabic ? Highest_ar : Highest_en) - \(myBidding.currentBid?.price ?? 0) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            
            bidLabel.text = String(format: "%@ - %.3f %@", appDele!.isForArabic ? Bid_ar : Bid_en, myBidding.myBid.price, appDele!.isForArabic ? KWD_ar : KWD_en)
            highestBidLabel.text = String(format: "%@ - %.3f %@", appDele!.isForArabic ? Highest_ar : Highest_en, myBidding.currentBid?.price ?? 0, appDele!.isForArabic ? KWD_ar : KWD_en)
            timerLabel.text = getTimeDifference(fromTime: Date(), toTime: myBidding.endDate)
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
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .appPrimaryColor
        return label
    }()
    
    private lazy var bidNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gradientSecondColor
        button.setTitle("Place a bid", for: .normal)
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
    var btnBidNowClick : (() -> ()) = {}
    @objc func handleBidTapped() {
        btnBidNowClick()
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
        
        let infoStack = UIStackView(arrangedSubviews: [itemNameLabel, bidLabel, highestBidLabel, timerStack, bidNowButton])
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
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
    
    func getTimeDifference(fromTime: Date, toTime: Date) -> String {
        let timeDifference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: fromTime, to: toTime)
        if !(timeDifference.day! < 0), !(timeDifference.hour! < 0), !(timeDifference.minute! < 0), !(timeDifference.second! < 0) {
            if timeDifference.day! == 0 {
                if timeDifference.hour! == 0 {
                     return "00:\(String(format: "%02d", timeDifference.minute!)):\(String(format: "%02d", timeDifference.second!)) Hours"
                }
                return "\(String(format: "%02d", timeDifference.hour!)):\(String(format: "%02d", timeDifference.minute!)):00 Hours"
            }
            return "\(timeDifference.day!) Days"
        }
        return ""
    }
}
