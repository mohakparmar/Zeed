//
//  AddVariantInfoCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 27/04/21.
//

import UIKit

class AddVariantInfoCell: UITableViewCell {
    let varientTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    let varientSubTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let varientInfoStack = UIStackView(arrangedSubviews: [varientTypeLabel, varientSubTypeLabel])
        varientInfoStack.alignment = .center
        varientInfoStack.distribution = .equalCentering
        
        addSubview(varientInfoStack)
        varientInfoStack.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
