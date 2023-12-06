//
//  CreateStartDateCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 09/05/21.
//

import UIKit

class CreateStartDateCell: UITableViewCell {
    //MARK: - Properties
    var date: Date? {
        didSet {
            guard let date = date else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy hh:mm a"
            dateLabel.text = formatter.string(from: date)
            dateLabel.textColor = .black
        }
    }
    
    //MARK: - UI Elements
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Auction_Start_Date_ar : Auction_Start_Date_en
        label.textColor = .darkGray
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
        
        contentView.addSubview(dateLabel)
        dateLabel.fillSuperview(padding: UIEdgeInsets(top: 14, left: 12, bottom: 15, right: 12))

        
        addSubview(seperatorView)
        seperatorView.anchor(left: dateLabel.leftAnchor, bottom: dateLabel.bottomAnchor, right: dateLabel.rightAnchor, height: 1)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
