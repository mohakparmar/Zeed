//
//  BiddingLiveHighestBidderInfoView.swift
//  Zeed
//
//  Created by Shrey Gupta on 05/04/21.
//

import UIKit

class BiddingLiveHighestBidderInfoView: UIView {
    //MARK: - Properties
    var highestBid: Double? {
        didSet {
            guard let highestBid = highestBid else { return }
            bidAmountLabel.text = "\(highestBid) KWD"
        }
    }
    
    var bidderName: String? {
        didSet {
            guard let bidderName = bidderName else { return }
            bidderNameLabel.text = bidderName
        }
    }
    
    //MARK: - UI Elements
    private let bidImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "highest_bid_tick").withRenderingMode(.alwaysOriginal)
        iv.setDimensions(height: 22, width: 25)
        return iv
    }()
    
    private let bidAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0.000 KWD"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let bidderNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mohammad Anwar"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .white
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configureView() {
        backgroundColor = .clear
        
        let bidInfoStack = UIStackView(arrangedSubviews: [bidImageView, bidAmountLabel])
        bidInfoStack.axis = .horizontal
        bidInfoStack.alignment = .fill
        bidInfoStack.distribution = .fill
        bidInfoStack.spacing = 8
        
        let mainStack = UIStackView(arrangedSubviews: [bidInfoStack, bidderNameLabel])
        mainStack.axis = .vertical
        mainStack.alignment = .trailing
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 5
        
        addSubview(mainStack)
        mainStack.fillSuperview()
    }
}
