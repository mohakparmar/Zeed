//
//  BiddingLiveProductInfoView.swift
//  Zeed
//
//  Created by Shrey Gupta on 05/04/21.
//

import UIKit

class BiddingLiveProductInfoView: UIView {
    //MARK: - properties
    var item: BidItem? {
        didSet {
            guard let item = item else { return }
            itemNameLabel.text = item.title
            itemImageView.loadImage(from: item.medias.first!.url)
            self.setUsernameAndDescription(for: item)
        }
    }
    
    //MARK: - ui elements
    private let itemImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.setDimensions(height: 50, width: 50)
        iv.layer.cornerRadius = 50/2
        
        return iv
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - selectors
    
    //MARK: - helper functions
    func configureView() {
        backgroundColor = .appBackgroundColor
        layer.cornerRadius = 8
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
        addShadow()
        
        itemImageView.setDimensions(height: 95, width: 95)

        let infoStack = UIStackView(arrangedSubviews: [itemImageView, itemNameLabel])
        infoStack.axis = .horizontal
        infoStack.alignment = .center
        infoStack.spacing = 8
        infoStack.distribution = .fill
        
        let descriptionStack = UIStackView(arrangedSubviews: [descriptionLabel])
        descriptionStack.axis = .vertical
        descriptionStack.distribution = .fillProportionally
        descriptionStack.alignment = .leading
        descriptionStack.spacing = 3
        
        let sellerStack = UIStackView(arrangedSubviews: [profileImageView, descriptionStack])
        sellerStack.alignment = .leading
        sellerStack.distribution = .fillProportionally
        sellerStack.axis = .horizontal
        sellerStack.spacing = 10
        
        let mainStack = UIStackView(arrangedSubviews: [infoStack, sellerStack])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        
        addSubview(mainStack)
        mainStack.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 18, paddingLeft: 18, paddingBottom: 18, paddingRight: 18)
    }
    
    func setUsernameAndDescription(for item: BidItem) {
        // SETTING CAPTION TEXT
        let attributedText = NSMutableAttributedString(string: item.owner.fullName, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold), .foregroundColor: UIColor.black])
        attributedText.append(NSMutableAttributedString(string: "  "))
        attributedText.append(NSMutableAttributedString(string: item.about, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light), .foregroundColor: UIColor.black]))
        
        descriptionLabel.attributedText = attributedText
        
        profileImageView.setUserImageUsingUrl(item.owner.image.url)
    }
}
