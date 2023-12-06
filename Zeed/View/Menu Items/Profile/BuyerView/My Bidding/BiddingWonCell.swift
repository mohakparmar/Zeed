//
//  BiddingWonCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class BiddingWonCell: UICollectionViewCell {
    //MARK: - Properties
    var myBidding: MyBiddingItem? {
        didSet {
            guard let myBidding = myBidding else { return }
            itemImageView.loadImage(from: myBidding.medias.first?.url ?? "")
            itemNameLabel.text = appDele!.isForArabic ?  myBidding.title : myBidding.title_ar
//            bidLabel.text = "\(appDele!.isForArabic ? Bid_ar : Bid_en) - \(myBidding.myBid.price) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            bidLabel.text = String(format: "%@ - %.3f %@", appDele!.isForArabic ? Bid_ar : Bid_en, myBidding.myBid.price, appDele!.isForArabic ? KWD_ar : KWD_en)
            timerLabel.text = getTimeDifference(fromTime: myBidding.endDate, toTime: Date())
            purchaseButton.isHidden = myBidding.isPurchased
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
    
    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gradientSecondColor
        button.setTitle(appDele!.isForArabic ? Purchase_ar : Purchase_en, for: .normal)
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
    
    var btnPurchaseClick : (() -> ()) = {}
    //MARK: - Selector
    @objc func handleBidTapped() {
        btnPurchaseClick()
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
        
        var infoStack = UIStackView(arrangedSubviews: [itemNameLabel, bidLabel, timerStack, purchaseButton])
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
                     return " 00 : \(String(format: "%02d", timeDifference.minute!)) : \(String(format: "%02d", timeDifference.second!))"
                }
                return " \(String(format: "%02d", timeDifference.hour!)) : \(String(format: "%02d", timeDifference.minute!)) : 00"
            }
            return "\(timeDifference.day!) Days"
        }
        return ""
    }
}
