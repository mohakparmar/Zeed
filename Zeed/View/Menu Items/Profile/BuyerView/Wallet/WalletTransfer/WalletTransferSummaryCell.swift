//
//  WalletTransferSummaryCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/04/21.
//

import UIKit

class WalletTransferSummaryCell: UITableViewCell {
    //MARK: - Properties
        
    var amount : String? {
        didSet {
            self.subTotalValueModeLabel.text = String(format: "%.3f %@", Double(self.amount ?? "0") ?? 0, appDele!.isForArabic ? KWD_ar : KWD_en)
            self.grandTotalLabel.text = String(format: "%.3f %@", Double(self.amount ?? "0") ?? 0, appDele!.isForArabic ? KWD_ar : KWD_en)
        }
    }
    
    //MARK: - UI Elements
    private let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let subTotalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Sub_Total_ar : Sub_Total_en
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let subTotalValueModeLabel: UILabel = {
        let label = UILabel()
        label.text = "0.000 \(appDele!.isForArabic ? KWD_ar : KWD_en)"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var subTotalContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [subTotalTitleLabel, subTotalValueModeLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let serviceChargeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Service_Charges_ar : Service_Charges_en
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let serviceChargeLabel: UILabel = {
        let label = UILabel()
        label.text = "0.000 \(appDele!.isForArabic ? KWD_ar : KWD_en)"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var serviceChargeContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [serviceChargeTitleLabel, serviceChargeLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()

    
    private let grandTotalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Total_ar : Total_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.appPrimaryColor
        return label
    }()
    
    private let grandTotalLabel: UILabel = {
        let label = UILabel()
        label.text = "0.000 \(appDele!.isForArabic ? KWD_ar : KWD_en)"
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var grandTotalContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [grandTotalTitleLabel, grandTotalLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
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
        selectionStyle = .none
        
        whiteView.layer.cornerRadius = 10
        whiteView.addShadow()
        
        
        let mainStack = UIStackView(arrangedSubviews: [subTotalContainer, serviceChargeContainer, grandTotalContainer])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually
        mainStack.spacing = 12
        mainStack.setCustomSpacing(20, after: serviceChargeContainer)
        
        addSubview(whiteView)
        whiteView.fillSuperview(padding: UIEdgeInsets(top: 25, left: 15, bottom: 25, right: 15))
        
        
        whiteView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
