//
//  MyOrderDetailSummaryCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/04/21.
//

import UIKit

class MyOrderDetailSummaryCell: UICollectionViewCell {
    //MARK: - Properties
    var orderItem: OrderItem? {
        didSet {
            guard let orderItem = orderItem else { return }
            
            orderIdValueModeLabel.text = "\(orderItem.invoiceNumber)"
            transactionTypeLabel.text = "\(orderItem.paymentType.firstCapitalized)"
            transactionIdLabel.text = "\(orderItem.invoiceNumber)"
            paymenyStatusLabel.text = "\(orderItem.paymentStatus.firstCapitalized)"
//            grandTotalLabel.text = "\(orderItem.grandTotal) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            grandTotalLabel.text = String(format: "%.3f %@", orderItem.grandTotal, appDele!.isForArabic ? KWD_ar : KWD_en)
            deliveryPrice.text = String(format: "%.3f %@", orderItem.deliveryCharges, appDele!.isForArabic ? KWD_ar : KWD_en)
            timeSlotValueModeLabel.text = orderItem.deliveryTimeSlot
        }
    }
    
    
    //MARK: - UI Elements
    
    private let paymentDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Order_Summary_ar : Order_Summary_en
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    
    private let timeSlotTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Delivery_Time_ar : Delivery_Time_en
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let timeSlotValueModeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var timeSlotContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeSlotTitleLabel, timeSlotValueModeLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()



    private let orderIdTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Order_No_ar : Order_No_en
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let orderIdValueModeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var orderIdContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [orderIdTitleLabel, orderIdValueModeLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let transactionTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Transaction_Type_ar : Transaction_Type_en
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let transactionTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var transactionTypeContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [transactionTypeTitleLabel, transactionTypeLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let transactionIdTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.text = appDele!.isForArabic ? Transaction_ID_ar : Transaction_ID_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let transactionIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var transactionIdContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [transactionIdTitleLabel, transactionIdLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let paymenyStatusTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Payment_Status_ar : Payment_Status_en
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let paymenyStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var paymenyStatusContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [paymenyStatusTitleLabel, paymenyStatusLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()


    
    private let deliveryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Delivery_Charge_ar : Delivery_Charge_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.appPrimaryColor
        return label
    }()
    
    private let deliveryPrice: UILabel = {
        let label = UILabel()
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
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
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var deliveryContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [deliveryTitleLabel, deliveryPrice])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var grandTotalContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [grandTotalTitleLabel, grandTotalLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helper Functions
    
    func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = 10
        addShadow()
        
        addSubview(paymentDetailsLabel)
        paymentDetailsLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 10, paddingRight: 10)
        
        let mainStack = UIStackView(arrangedSubviews: [orderIdContainer, transactionTypeContainer, transactionIdContainer,
                                                       paymenyStatusContainer, timeSlotContainer, deliveryContainer, grandTotalContainer])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually
        mainStack.spacing = 12
        mainStack.setCustomSpacing(20, after: timeSlotContainer)
        
        addSubview(mainStack)
        mainStack.anchor(top: paymentDetailsLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 10,paddingBottom: 10, paddingRight: 10)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

