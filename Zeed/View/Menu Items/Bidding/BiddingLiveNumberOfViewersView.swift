//
//  BiddingLiveNumberOfViewersView.swift
//  Zeed
//
//  Created by Shrey Gupta on 05/04/21.
//

import UIKit

class BiddingLiveNumberOfViewersView: UIView {
    //MARK: - Properties
    var numberOfViewers: Int? {
        didSet {
            guard let number = numberOfViewers else { return }
            numberOfViewersLabel.text = "\(number)"
        }
    }
    
    //MARK: - UI Elements
    private let eyeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "white_eye").withRenderingMode(.alwaysOriginal)
        iv.setDimensions(height: 25, width: 25)
        return iv
    }()
    
    private let numberOfViewersLabel: UILabel = {
        let label = UILabel()
        label.text = "2.5k"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configureView() {
        backgroundColor = .clear
        
        let mainStack = UIStackView(arrangedSubviews: [eyeImageView, numberOfViewersLabel])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 8
        
        addSubview(mainStack)
        mainStack.fillSuperview()
    }
}
