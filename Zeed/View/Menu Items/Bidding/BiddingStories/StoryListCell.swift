//
//  StoryListCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit
import EZYGradientView

final class StoryListCell: UICollectionViewCell {
    
    //MARK: - Public iVars
    public var story: IGStory? {
        didSet {
            self.profileNameLabel.text = story?.user.name
            if let picture = story?.user.picture {
                self.profileImageView.imageView.setImage(url: picture)
            }
        }
    }
    public var userDetails: (String,String)? {
        didSet {
            if let details = userDetails {
                self.profileNameLabel.text = details.0
                self.profileImageView.imageView.setImage(url: details.1)
            }
        }
    }
    
    //MARK: -  Private ivars
    private lazy var profileImageView: IGRoundedView = {
        let roundedView = IGRoundedView()
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.insertSubview(gradientView, at: 0)
        return roundedView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var gradientView: EZYGradientView = {
        let gradientView = EZYGradientView()
        gradientView.frame = .init(x: 0, y: 0, width: 67, height: 70)
        gradientView.firstColor = .gradientFirstColor
        gradientView.secondColor = .gradientSecondColor
        gradientView.colorRatio = 0.5
        gradientView.fadeIntensity = 0.5
        return gradientView
    }()
    
    //MARK: - Overriden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUIElements()
        installLayoutConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Private functions
    private func loadUIElements() {
        addSubview(profileImageView)
        addSubview(profileNameLabel)
    }
    private func installLayoutConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 67),
            profileImageView.heightAnchor.constraint(equalToConstant: 67),
            profileImageView.igTopAnchor.constraint(equalTo: self.igTopAnchor, constant: 8),
            profileImageView.igCenterXAnchor.constraint(equalTo: self.igCenterXAnchor)])

        NSLayoutConstraint.activate([
            profileNameLabel.igLeftAnchor.constraint(equalTo: self.igLeftAnchor),
            profileNameLabel.igRightAnchor.constraint(equalTo: self.igRightAnchor),
            profileNameLabel.igTopAnchor.constraint(equalTo: self.profileImageView.igBottomAnchor, constant: 0),
            profileNameLabel.igCenterXAnchor.constraint(equalTo: self.igCenterXAnchor),
            self.igBottomAnchor.constraint(equalTo: profileNameLabel.igBottomAnchor, constant: 3)])
        
        layoutIfNeeded()
    }
}


