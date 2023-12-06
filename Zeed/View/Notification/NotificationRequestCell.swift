//
//  NotificationRequestCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit

protocol NotificationRequestCellDelegate: class {
    func handleAcceptUser(user: User)
    func handleRejectUser(user: User)
}

class NotificationRequestCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: NotificationRequestCellDelegate?
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            notiImage.loadImage(from: user.image.url)
            usernameLabel.text = user.fullName
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
    
    private let followRequestLabel: UILabel = {
        let label = UILabel()
        label.text = "has sent you a follow request"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.8)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBrightBlueColor
        
        button.layer.cornerRadius = 9
        
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        return button
    }()
    
    private lazy var rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reject", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBrightBlueColor
        
        button.layer.cornerRadius = 9
        button.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
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
    @objc func handleAccept() {
        guard let user = user else { return }
        delegate?.handleAcceptUser(user: user)
    }
    
    @objc func handleReject() {
        guard let user = user else { return }
        delegate?.handleRejectUser(user: user)
    }
    
    //MARK: - Helper Function
    func configureCell() {
        notiImage.setDimensions(height: (frame.height/2), width: (frame.height/2))
        notiImage.layer.cornerRadius = ((frame.height/2))/2
        
        let buttonStack = UIStackView(arrangedSubviews: [acceptButton, rejectButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        buttonStack.setDimensions(height: 42, width: frame.width - (frame.height/2) - 30)
        
        let nameRequestButtonsStack = UIStackView(arrangedSubviews: [usernameLabel, followRequestLabel, buttonStack])
        nameRequestButtonsStack.axis = .vertical
        nameRequestButtonsStack.alignment = .leading
        nameRequestButtonsStack.setCustomSpacing(15, after: followRequestLabel)
        
        
        let imageAndNameStack = UIStackView(arrangedSubviews: [notiImage, nameRequestButtonsStack])
        imageAndNameStack.axis = .horizontal
        imageAndNameStack.spacing = 10
        imageAndNameStack.alignment = .leading
        imageAndNameStack.distribution = .fillProportionally

        addSubview(imageAndNameStack)
        imageAndNameStack.centerX(inView: self)
        imageAndNameStack.centerY(inView: self)
        
    }
}
