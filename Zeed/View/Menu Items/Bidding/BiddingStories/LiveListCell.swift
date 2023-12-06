//
//  LiveListCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit
import EZYGradientView

final class LiveListCell: UICollectionViewCell {
    
    //MARK: - Public iVars
    public var user: User? {
        didSet {
            guard let user = user else { return }
            self.profileNameLabel.text = user.userName
            self.profileImageView.imageView.setUserImageUsingUrl(user.image.url)
        }
    }
//    public var userDetails: (String,String)? {
//        didSet {
//            if let details = userDetails {
//                self.profileNameLabel.text = details.0
//                self.profileImageView.imageView.setImage(url: details.1)
//            }
//        }
//    }
    
    //MARK: -  Private ivars
    private lazy var gradientView: EZYGradientView = {
        let gradientView = EZYGradientView()
        gradientView.frame = .init(x: 0, y: 0, width: 67, height: 70)
        gradientView.firstColor = .gradientFirstColor
        gradientView.secondColor = .gradientSecondColor
        gradientView.colorRatio = 0.5
        gradientView.fadeIntensity = 0.5
        return gradientView
    }()
    
    
    private lazy var profileImageView: IGRoundedView = {
        let roundedView = IGRoundedView()
        roundedView.enableBorder(enabled: true, cellType: .live)
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.insertSubview(gradientView, at: 0)
        return roundedView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    
        return label
    }()
    
    private lazy var liveLabel: SGLiveView = {
        let view = SGLiveView()
        
        view.blinkInterval = 0.8
        
        view.liveLabel.text = "Live"
        view.liveLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        view.liveLabel.textColor = .white
        
        view.addSubview(view.liveLabel)
        view.liveLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        view.liveLabel.contentMode = .center
        view.liveLabel.textAlignment = .center
        
        view.layer.cornerRadius = 2
        
        view.backgroundColor = .gradientSecondColor
        
        return view
    }()

    
    //MARK: - Overriden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUIElements()
        installLayoutConstraints()
        
        liveLabel.start()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Private functions
    private func loadUIElements() {
        addSubview(profileImageView)
        addSubview(profileNameLabel)
//        addSubview(liveLabel)
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
        
//        liveLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: -12, width: 35, height: 15)
//        liveLabel.centerX(inView: profileImageView)
        
        layoutIfNeeded()
    }
}



