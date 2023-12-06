//
//  BiddingPayFooterView.swift
//  Zeed
//
//  Created by Shrey Gupta on 03/04/21.
//

import UIKit

protocol BiddingPayFooterViewDelegate: class {
    func didTapPay()
}

class BiddingPayFooterView: UIView {
    //MARK: - Properties
    weak var delegate: BiddingPayFooterViewDelegate?
    
    //MARK: - Elements
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0.000 KWD"
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBrightBlueColor
        button.setTitle("Pay", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func didTapPay() {
        delegate?.didTapPay()
    }
    
    //MARK: - Helper Functions
    func configureView() {
        backgroundColor = .white
        layer.cornerRadius = 6
        clipsToBounds = true
        addShadow()
        
        let detailStack = UIStackView(arrangedSubviews: [totalLabel, totalAmountLabel])
        detailStack.axis = .vertical
        detailStack.alignment = .leading
        detailStack.distribution = .fillProportionally
        
        payButton.setDimensions(height: 50, width: 120)
        
        let mainStack = UIStackView(arrangedSubviews: [detailStack, payButton])
        mainStack.alignment = .center
        mainStack.distribution = .equalCentering
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
    }
}

