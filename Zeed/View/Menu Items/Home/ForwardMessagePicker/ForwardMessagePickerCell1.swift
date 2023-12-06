//
//  ForwardMessagePickerCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 27/04/21.
//

import UIKit

class ForwardMessagePickerCell: UICollectionViewCell {
    //MARK: - Properties
    var user: User? {
        didSet {
            guard let user = user else { return }
            if user.isSelected {
                profileImageView.image = UIImage(named: "check3")
            } else {
                profileImageView.setUserImageUsingUrl(user.image.url)
            }
            nameLabel.text = user.userName
            aboutLabel.text = user.about
            if user.userName == "iosbguserrs" {
                print("\(user.about)")
            }
        }
    }
    
    //MARK: - UI Elements
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = #imageLiteral(resourceName: "ic_retry")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .random
        
        iv.setDimensions(height: 70, width: 70)
        iv.layer.cornerRadius = 35
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 2
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
    //MARK: - Selectors
    
    
    //MARK: - Helper Function
    func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = 5
    
        let stack = UIStackView(arrangedSubviews: [nameLabel, aboutLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        
        let mainStack = UIStackView(arrangedSubviews: [profileImageView, stack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .fill
        mainStack.spacing = 10
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9))
    }
}
