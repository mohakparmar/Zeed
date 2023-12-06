//
//  ProfileUserInfo.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

protocol ProfileUserInfoDelegate: AnyObject {
    func didTapEditButton()
}

class ProfileUserInfo: UIView {
    //MARK: - Properties
    weak var delegate: ProfileUserInfoDelegate?
    
    lazy var user: User? = AppUser.shared.getDefaultUser()
    
    //MARK: - UI Elements
    private lazy var userProfileImage: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "edit").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc func handleEdit() {
        delegate?.didTapEditButton()
    }
    
    //MARK: - Helper Function
    func configureView() {
        backgroundColor = .appBackgroundColor
        
        userProfileImage.setDimensions(height: 90, width: 90)
        userProfileImage.layer.cornerRadius = (90)/2

        let imageNameStack = UIStackView(arrangedSubviews: [userProfileImage, userNameLabel])
        imageNameStack.alignment = .center
        imageNameStack.distribution = .fillProportionally
        imageNameStack.spacing = 10
        
        let mainStack = UIStackView(arrangedSubviews: [imageNameStack, editButton])
        mainStack.alignment = .top
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 10
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18))
    }
    
    func configureUser() {
        guard let user = user else { return }
        userNameLabel.text = user.userName
        userProfileImage.loadImage(from: user.image.url)
        
        
    }
}
