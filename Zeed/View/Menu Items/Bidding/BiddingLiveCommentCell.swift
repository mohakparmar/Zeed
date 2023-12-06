//
//  BiddingLiveCommentCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 05/04/21.
//

import UIKit

class BiddingLiveCommentCell: UICollectionViewCell {
    
    //MARK: - Properties
    var comment: CommentObject! {
        didSet{
            self.setUsernameAndComment(for: comment)
        }
    }
    
    //MARK: - UI Elements
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .random
        
        iv.setDimensions(height: 50, width: 50)
        iv.layer.cornerRadius = 50/2
        
        return iv
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
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
        
        let commentTimeStack = UIStackView(arrangedSubviews: [commentLabel])
        commentTimeStack.axis = .vertical
        commentTimeStack.distribution = .fillProportionally
        commentTimeStack.alignment = .leading
        commentTimeStack.spacing = 3
        
        let mainStack = UIStackView(arrangedSubviews: [profileImageView, commentTimeStack])
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        mainStack.axis = .horizontal
        mainStack.spacing = 2
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
    }
    
    
    func setUsernameAndComment(for comment: CommentObject) {
        // SETTING CAPTION TEXT
        let attributedText = NSMutableAttributedString(string: "\(comment.userName)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold), .foregroundColor: UIColor.white])
        attributedText.append(NSMutableAttributedString(string: "  "))
        attributedText.append(NSMutableAttributedString(string: "\(comment.text)", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light), .foregroundColor: UIColor.white]))
        
        commentLabel.attributedText = attributedText

    }
    
}
