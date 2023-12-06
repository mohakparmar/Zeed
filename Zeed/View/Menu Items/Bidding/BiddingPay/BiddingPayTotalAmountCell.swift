//
//  BiddingPayTotalAmountCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 03/04/21.
//

import UIKit

class BiddingPayTotalAmountCell: UITableViewCell {
    //MARK: - Properties
    
    //MARK: - UI Elements
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
    
    private let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.addShadow()
        return view
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
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        let mainStack = UIStackView(arrangedSubviews: [totalLabel, totalAmountLabel])
        mainStack.alignment = .center
        mainStack.distribution = .equalCentering
        
        whiteView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        
        addSubview(whiteView)
        whiteView.fillSuperview(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        
    }
}

