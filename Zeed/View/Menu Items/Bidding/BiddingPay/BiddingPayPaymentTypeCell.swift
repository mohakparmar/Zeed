//
//  BiddingPayPaymentTypeCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/04/21.
//

import UIKit

class BiddingPayPaymentTypeCell: UITableViewCell {
    //MARK: - Properties
    var type: BiddingPayPaymentTypes? {
        didSet {
            guard let type = type else { return }
            typeImage.image = type.image
            typeLabel.text = type.description
        }
    }
    
    //MARK: - UI Elements
    private let typeImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        layer.cornerRadius = 8
        clipsToBounds = true
        
        typeImage.setDimensions(height: frame.height - 20, width: frame.height - 20)
        
        let mainStack = UIStackView(arrangedSubviews: [typeImage, typeLabel])
        mainStack.spacing = 10
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
}
