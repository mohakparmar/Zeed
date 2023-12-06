//
//  CreateSaleTypeCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

protocol CreateSaleTypeCellDelegate: AnyObject {
    func didSelectSaleType(type: PostBaseType)
}

class CreateSaleTypeCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CreateSaleTypeCellDelegate?
    var isEditPossible : Bool = true
    
    var selectedSaleType: PostBaseType? {
        didSet {
            guard let selectedSaleType = selectedSaleType else { return }
            
            switch selectedSaleType {
            case .normalSelling:
                deselectAll()
                fixedButton.isSelected.toggle()
                
                if fixedButton.isSelected {
                    fixedButton.backgroundColor = .appPrimaryColor
                    fixedButton.layer.borderWidth = 0
                } else {
                    fixedButton.backgroundColor = .appBackgroundColor
                    fixedButton.layer.borderWidth = 0.5
                }
            case .normalBidding:
                deselectAll()
                auctionButton.isSelected.toggle()
                
                if auctionButton.isSelected {
                    auctionButton.backgroundColor = .appPrimaryColor
                    auctionButton.layer.borderWidth = 0
                } else {
                    auctionButton.backgroundColor = .appBackgroundColor
                    auctionButton.layer.borderWidth = 0.5
                }
            case .liveBidding:
                deselectAll()
                liveAuctionButton.isSelected.toggle()
                
                if liveAuctionButton.isSelected {
                    liveAuctionButton.backgroundColor = .appPrimaryColor
                    liveAuctionButton.layer.borderWidth = 0
                } else {
                    liveAuctionButton.backgroundColor = .appBackgroundColor
                    liveAuctionButton.layer.borderWidth = 0.5
                }
            }
        }
    }
    
    //MARK: - UI Elements
    private lazy var fixedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(appDele!.isForArabic ? Fixed_ar : Fixed_en, for: .normal)
        
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.backgroundColor = .appBackgroundColor
        button.layer.cornerRadius = 9
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.appPrimaryColor.cgColor
        
        button.addTarget(self, action: #selector(handleFixedTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var auctionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(appDele!.isForArabic ? Auction_ar : Auction_en, for: .normal)
        
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.backgroundColor = .appBackgroundColor
        button.layer.cornerRadius = 9
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.appPrimaryColor.cgColor
        
        button.addTarget(self, action: #selector(handleAuctionTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var liveAuctionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(appDele!.isForArabic ? Live_Auction_ar : Live_Auction_en, for: .normal)
        
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.backgroundColor = .appBackgroundColor
        button.layer.cornerRadius = 9
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.appPrimaryColor.cgColor
        
        button.addTarget(self, action: #selector(handleLiveAuctionTapped), for: .touchUpInside)
        
        return button
    }()
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleFixedTapped() {
        if isEditPossible == true {
            deselectAll()
            fixedButton.isSelected.toggle()
            
            if fixedButton.isSelected {
                fixedButton.backgroundColor = .appPrimaryColor
                fixedButton.layer.borderWidth = 0
            } else {
                fixedButton.backgroundColor = .appBackgroundColor
                fixedButton.layer.borderWidth = 0.5
            }
        }
        
        delegate?.didSelectSaleType(type: .normalSelling)
    }
    
    @objc func handleAuctionTapped() {
        if isEditPossible == true {
            deselectAll()
            auctionButton.isSelected.toggle()
            
            if auctionButton.isSelected {
                auctionButton.backgroundColor = .appPrimaryColor
                auctionButton.layer.borderWidth = 0
            } else {
                auctionButton.backgroundColor = .appBackgroundColor
                auctionButton.layer.borderWidth = 0.5
            }
        }
         
        delegate?.didSelectSaleType(type: .normalBidding)
    }
    
    @objc func handleLiveAuctionTapped() {
        if isEditPossible == true {
            deselectAll()
            liveAuctionButton.isSelected.toggle()
            
            if liveAuctionButton.isSelected {
                liveAuctionButton.backgroundColor = .appPrimaryColor
                liveAuctionButton.layer.borderWidth = 0
            } else {
                liveAuctionButton.backgroundColor = .appBackgroundColor
                liveAuctionButton.layer.borderWidth = 0.5
            }
        }
        
        delegate?.didSelectSaleType(type: .liveBidding)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
//        let buttonStack = UIStackView(arrangedSubviews: [fixedButton, auctionButton, liveAuctionButton])
        let buttonStack = UIStackView(arrangedSubviews: [fixedButton, auctionButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        
        contentView.addSubview(buttonStack)
        buttonStack.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 10, right: 12))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
    
    func deselectAll() {
        fixedButton.isSelected = false
        auctionButton.isSelected = false
        liveAuctionButton.isSelected = false
        
        fixedButton.backgroundColor = .appBackgroundColor
        fixedButton.layer.borderWidth = 0.5
        
        auctionButton.backgroundColor = .appBackgroundColor
        auctionButton.layer.borderWidth = 0.5
        
        liveAuctionButton.backgroundColor = .appBackgroundColor
        liveAuctionButton.layer.borderWidth = 0.5
    }
}
