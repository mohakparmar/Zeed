//
//  NotificationActivityCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit

class NotificationActivityCell: UICollectionViewCell {
    //MARK: - Properties
    var notification: UserNotification? {
        didSet {
            guard let noti = notification else {return }
            notiImage.loadImage(from: noti.fromUserPicture)
            usernameLabel.text = noti.fromUsername
            
            timeLabel.text = noti.atTime.timeAgo()
            
            switch noti.type {
            case .like:
                notiInfoLabel.text = "liked your post"
            case .comment:
                notiInfoLabel.text = "commented on your post"
            case .follow:
                notiInfoLabel.text = "started following you"
            }
        }
    }

    var objGeneral: GeneralNotification? {
        didSet {
            guard let noti = objGeneral else {return }
            notiImage.loadImage(from: noti.userImage)
            usernameLabel.text = noti.userName
            timeLabel.text = noti.atTime.timeAgo()
            notiInfoLabel.text = noti.text
        }
    }

    
    
    //MARK: - UI Elements
    
    private lazy var notiImage: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        image.clipsToBounds = true
        return image
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let notiInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.85)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.lightGray
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
    
    //MARK: - Helper Functions
    func configureCell() {
        addSubview(notiImage)
        notiImage.anchor(left: leftAnchor, paddingLeft: 10)
        notiImage.setDimensions(height: frame.height - 8, width: frame.height - 8)
        notiImage.layer.cornerRadius = (frame.height - 8)/2
        notiImage.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, notiInfoLabel])
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.axis = .horizontal
        
        let mainStack = UIStackView(arrangedSubviews: [stack, timeLabel])
        mainStack.axis = .vertical
        mainStack.distribution = .fillProportionally
        mainStack.alignment = .leading
        mainStack.spacing = 3
        
        addSubview(mainStack)
        mainStack.anchor(left: notiImage.rightAnchor, paddingLeft: 10)
        mainStack.centerY(inView: self)
        
        
//        addSubview(usernameLabel)
//        usernameLabel.anchor(left: notiTypeImage.rightAnchor, paddingLeft: 10)
//        usernameLabel.centerY(inView: self)
//
//        addSubview(notiInfoLabel)
//        notiInfoLabel.anchor(left: usernameLabel.rightAnchor, paddingLeft: 5)
//        notiInfoLabel.centerY(inView: self)
    }

}
