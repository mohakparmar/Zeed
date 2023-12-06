//
//  MessageCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/04/21.
//

import UIKit

class MessageCell: UICollectionViewCell {
    //MARK: - Properties
    
    //MARK: - UI Elements
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.setDimensions(height: 60, width: 60)
        iv.layer.cornerRadius = 60/2
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.numberOfLines = 2
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.5, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    let notificationNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    lazy var notificationView: UIView = {
        let view = UIView()
        view.backgroundColor = .appPrimaryColor
        
        view.setDimensions(height: 21, width: 21)
        view.layer.cornerRadius = 21/2
        
        view.addSubview(notificationNumberLabel)
        notificationNumberLabel.centerX(inView: view)
        notificationNumberLabel.centerY(inView: view)
        
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func configureUI() {
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, lastMessageLabel])
        infoStack.axis = .vertical
        infoStack.distribution = .fillProportionally
        infoStack.alignment = .leading
        infoStack.spacing = 3
        
        let timeNotiStack = UIStackView(arrangedSubviews: [timeLabel, notificationView])
        timeNotiStack.axis = .vertical
        timeNotiStack.distribution = .fillProportionally
        timeNotiStack.alignment = .trailing
        timeNotiStack.spacing = 3
        timeNotiStack.anchor(width: 70)
        
        
        let imageInfoStack = UIStackView(arrangedSubviews: [profileImageView, infoStack])
        imageInfoStack.axis = .horizontal
        imageInfoStack.alignment = .center
        imageInfoStack.spacing = 15
        imageInfoStack.distribution = .fillProportionally
        
        let mainStack = UIStackView(arrangedSubviews: [imageInfoStack, timeNotiStack])
        mainStack.alignment = .center
        mainStack.distribution = .equalCentering
        
        addSubview(mainStack)
        mainStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 10, paddingRight: 10)
        mainStack.centerY(inView: self)
    }
}

