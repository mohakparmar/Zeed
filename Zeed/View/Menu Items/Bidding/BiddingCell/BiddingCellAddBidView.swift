//
//  BiddingCellAddBidView.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/04/21.
//

import UIKit
import GMStepper

protocol BiddingCellAddBidViewDelegate: AnyObject {
    func addBidView(_ addBidView: BiddingCellAddBidView, didBidWithAmount amount: Double, forItem item: BidItem)
}

class BiddingCellAddBidView: UIView {
    //MARK: - Properties
    weak var delegate: BiddingCellAddBidViewDelegate?
    
    var item: BidItem?
    
    var maxPrice: Double? {
        didSet {
            guard let maxPrice = maxPrice else { return }
            amountStepper.value = (maxPrice + maxPrice * 0.1)
            amountStepper.stepValue = maxPrice * 0.1
            amountStepper.minimumValue = maxPrice
            bidPriceLabel.text = "\(maxPrice) KWD"
            
            amountStepper.maximumValue = 9999999
        }
    }
    
    //MARK: - UI Elements
    private let currentBidLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Bid"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        return label
    }()
    
    private let bidPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 6
        return label
    }()
    
    private let yourBidLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Bid"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        return label
    }()
    
    private let minimumBidLabel: UILabel = {
        let label = UILabel()
        label.text = "Minimum increase in the Bid is 10%"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var amountStepper: GMStepper = {
        let stepper = GMStepper()
        stepper.buttonsBackgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.6)
        stepper.buttonsTextColor = .white
        
        stepper.labelBackgroundColor = .white
        stepper.labelTextColor = UIColor.appPrimaryColor.withAlphaComponent(0.6)
        stepper.labelFont = UIFont(name: "AvenirNext-Bold", size: 19)!
        
        stepper.limitHitAnimationColor = .systemRed
        return stepper
    }()
    
    private lazy var bidButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Bid", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 5
        
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
    
    //MARK: - Selectos
    @objc func handleBidTapped() {
        guard let item = item else { return }
        delegate?.addBidView(self, didBidWithAmount: amountStepper.value.round(to: 3), forItem: item)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .appBackgroundColor
        layer.cornerRadius = 8
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
        addShadow()

        let currentBidStack = UIStackView(arrangedSubviews: [currentBidLabel, bidPriceLabel])
        currentBidStack.axis = .vertical
        currentBidStack.spacing = 1
        
        let bidStepper = UIStackView(arrangedSubviews: [yourBidLabel, amountStepper])
        bidStepper.axis = .vertical
        bidStepper.spacing = 1
        
        currentBidStack.setDimensions(height: 80, width: 200)
        bidStepper.setDimensions(height: 90, width: 250)
        
        bidPriceLabel.setDimensions(height: 40, width: 200)
        amountStepper.setDimensions(height: 45, width: 250)
        
        bidButton.setDimensions(height: 45, width: frame.width - 30)

        let mainStack = UIStackView(arrangedSubviews: [currentBidStack, bidStepper, minimumBidLabel, bidButton])
        mainStack.axis = .vertical
        mainStack.alignment = .leading
        mainStack.distribution = .fillProportionally
        
        addSubview(mainStack)
        mainStack.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15)
        
    }
}
