//
//  CartCheckoutDeliveryTimeCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 08/04/21.
//

import UIKit

class CartCheckoutDeliveryTimeCell: UITableViewCell {
    //MARK: - Properties
    var timeSlot: TimeSlot? {
        didSet {
            guard let timeSlot = timeSlot else { return }
            categoryTitleLabel.text = timeSlot.slot
        }
    }
    
    //MARK: - UI Elements
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Please_select_delivery_time_slot_ar : Please_select_delivery_time_slot_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        
        addSubview(categoryTitleLabel)
        categoryTitleLabel.fillSuperview(padding: UIEdgeInsets(top: 4, left: 12, bottom: 15, right: 12))
        
        addSubview(seperatorView)
        seperatorView.anchor(left: categoryTitleLabel.leftAnchor, bottom: categoryTitleLabel.bottomAnchor, right: categoryTitleLabel.rightAnchor, height: 1)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

