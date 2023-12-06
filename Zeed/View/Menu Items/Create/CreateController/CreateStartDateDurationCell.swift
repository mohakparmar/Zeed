//
//  CreateStartDateDurationCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 18/08/21.
//

import UIKit

protocol CreateStartDateDurationCellDelegate {
    func handleDateTapped()
    func handleDurationTapped()
}

class CreateStartDateDurationCell: UITableViewCell {
    //MARK: - Properties
    var delegate: CreateStartDateDurationCellDelegate?
    
    var date: Date? {
        didSet {
            guard let date = date else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            startDateLabel.text = formatter.string(from: date)
            startDateLabel.textColor = .black
        }
    }
    
    var duration: AuctionDuration? {
        didSet {
            guard let duration = duration else { return }
            durationLabel.text = duration.rawValue
            durationLabel.textColor = .black
        }
    }
    
    //MARK: - UI Elements
    private lazy var startDateLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Auction_Start_Date_ar : Auction_Start_Date_en
        label.textColor = .darkGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDateTapped))
        tap.numberOfTapsRequired = 1
        
        label.isUserInteractionEnabled = true
        label.gestureRecognizers = [tap]
        return label
    }()
    
    private let dateSeperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        return seperatorView
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Duration_ar : Duration_en
        label.textColor = .darkGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDurationTapped))
        tap.numberOfTapsRequired = 1
        
        label.isUserInteractionEnabled = true
        label.gestureRecognizers = [tap]
        return label
    }()
    
    private let durationSeperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        return seperatorView
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
    @objc func handleDateTapped() {
        delegate?.handleDateTapped()
    }
    
    @objc func handleDurationTapped() {
        delegate?.handleDurationTapped()
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        dateSeperatorView.anchor(height: 1)
        durationSeperatorView.anchor(height: 1)
        
        let dateStack = UIStackView(arrangedSubviews: [startDateLabel, dateSeperatorView])
        dateStack.alignment = .fill
        dateStack.axis = .vertical
        dateStack.distribution = .fillProportionally
        
        let durationStack = UIStackView(arrangedSubviews: [durationLabel, durationSeperatorView])
        durationStack.alignment = .fill
        durationStack.axis = .vertical
        durationStack.distribution = .fillProportionally
        
        let mainStack = UIStackView(arrangedSubviews: [dateStack, durationStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually
        mainStack.spacing = 12
        
        contentView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 14, left: 12, bottom: 15, right: 12))
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

