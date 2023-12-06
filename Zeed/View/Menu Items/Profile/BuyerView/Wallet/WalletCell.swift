//
//  WalletCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/04/21.
//

import UIKit

class WalletCell: UITableViewCell {
    //MARK: - Properties
    var isFirstCell = false {
        didSet {
            if isFirstCell {
                topDottedView.alpha = 0
            } else {
                topDottedView.alpha = 1
            }
        }
    }
    var isLastCell = false {
        didSet {
            if isLastCell {
                bottomDottedView.alpha = 0
            } else {
                bottomDottedView.alpha = 1
            }
        }
    }
    
    var objTran : WalletTransaction? {
        didSet {
            if objTran?.natureOfTransaction == "debit" {
                transactionTypeLabel.text = "Debited for order : \(objTran?.orderNumber ?? "")"
                transactionAmountLabel.text = "- \(objTran?.walletAmount ?? "") \(appDele!.isForArabic ?  KWD_ar : KWD_en)"
                transactionAmountLabel.text = String(format: "- %.3f %@ ", (Double(objTran?.walletAmount ?? "0") ?? 0.0), appDele!.isForArabic ?  KWD_ar : KWD_en)
                transactionAmountLabel.textColor = .systemRed
            } else if objTran?.natureOfTransaction == "credit" {
                transactionAmountLabel.textColor = .systemGreen
                transactionTypeLabel.text = "Credit for cancellation of order : \(objTran?.orderNumber ?? "")"
                transactionAmountLabel.text = "+ \(objTran?.walletAmount ?? "") \(appDele!.isForArabic ? KWD_ar : KWD_en)"
                transactionAmountLabel.text = String(format: "+ %.3f %@ ", (Double(objTran?.walletAmount ?? "0") ?? 0.0), appDele!.isForArabic ?  KWD_ar : KWD_en)

            }
            dateValueLabel.text = objTran?.updatedAt
        }
    }
    
    //MARK: - UI Elements
    private let bulletView: UIView = {
        let view = UIView()
        view.backgroundColor = .appPrimaryColor
        view.setDimensions(height: 12, width: 12)
        view.layer.cornerRadius = 12/2
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.appBackgroundColor.cgColor
        return view
    }()
    
    private let transactionTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Refund"
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let transactionAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "+ 5.500 KWD"
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Date_ar : Date_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let dateValueLabel: UILabel = {
        let label = UILabel()
        label.text = "24/03/2021"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let topDottedView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray
        return lineView
    }()
    
    private let bottomDottedView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray
        return lineView
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
        selectionStyle = .none
        backgroundColor = .backgroundWhiteColor
        
        let infoStack = UIStackView(arrangedSubviews: [transactionTypeLabel, transactionAmountLabel])
        infoStack.axis = .vertical
        infoStack.alignment = .leading
        infoStack.spacing = 4
        infoStack.distribution = .fillProportionally
        
        let dateStack = UIStackView(arrangedSubviews: [dateLabel, dateValueLabel])
        dateStack.axis = .vertical
        dateStack.alignment = .trailing
        dateStack.spacing = 4
        dateStack.distribution = .fillProportionally
        
        let infoDateStack = UIStackView(arrangedSubviews: [infoStack, dateStack])
        infoDateStack.axis = .horizontal
        infoDateStack.alignment = .fill
        infoDateStack.distribution = .equalSpacing
        
        let mainStack = UIStackView(arrangedSubviews: [bulletView, infoDateStack])
        mainStack.spacing = 16
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        
        addSubview(topDottedView)
        topDottedView.anchor(top: topAnchor, bottom: bulletView.topAnchor, paddingBottom: 3, width: 1)
        topDottedView.centerX(inView: bulletView)
        
        addSubview(bottomDottedView)
        bottomDottedView.anchor(top: bulletView.bottomAnchor, bottom: bottomAnchor, paddingTop: 3, width: 1)
        bottomDottedView.centerX(inView: bulletView)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
