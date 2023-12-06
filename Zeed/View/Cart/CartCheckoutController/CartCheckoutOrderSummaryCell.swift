//
//  CartCheckoutOrderSummaryCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 08/04/21.
//

import UIKit

class CartCheckoutOrderSummaryCell: UITableViewCell {
    //MARK: - Properties
    var subtotalAmount: Double? {
        didSet{
            guard let subtotalAmount = subtotalAmount else { return }
            subtotalLabel.text = "\(subtotalAmount) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            subtotalLabel.text = String(format: "%.3f %@", subtotalAmount, appDele!.isForArabic ? KWD_ar : KWD_en)
        }
    }
    
    var deliveryChargesAmount: Double? {
        didSet{
            guard let deliveryChargesAmount = deliveryChargesAmount else { return }
            deliveryChargesLabel.text = "\(deliveryChargesAmount) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            deliveryChargesLabel.text = String(format: "%.3f %@", deliveryChargesAmount, appDele!.isForArabic ? KWD_ar : KWD_en)

        }
    }
    
    var appliedCoupon: Coupon? {
        didSet{
            guard let coupon = appliedCoupon else { return }
            codeAppliedLabel.text = coupon.couponCode
            discountLabel.text = coupon.discountType == .amount ? "\(coupon.discountValue) \(appDele!.isForArabic ? KWD_ar : KWD_en)" : "\(coupon.discountValue) %"
        }
    }
    
    var totalAmount: Double? {
        didSet{
            guard let totalAmount = totalAmount else { return }
            totalLabel.text = String(format: "%.3f %@", totalAmount, appDele!.isForArabic ? KWD_ar : KWD_en)
        }
    }
    //MARK: - UI Elements
    private let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.addShadow()
        return view
    }()
    
    private let subtotalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Sub_Total_ar : Sub_Total_en
        label.textColor = UIColor.darkGray.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let subtotalLabel: UILabel = {
        let label = UILabel()
        label.text = "loading..."
        return label
    }()
    
    private let deliveryChargesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Delivery_Charge_ar : Delivery_Charge_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let deliveryChargesLabel: UILabel = {
        let label = UILabel()
        label.text = "loading..."
        return label
    }()
    
    private let codeAppliedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Coupon_Applied_ar : Coupon_Applied_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let codeAppliedLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? None_ar : None_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let discountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Discount_ar : Discount_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let discountLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? None_ar : None_en
        return label
    }()
    
    private let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Total_ar : Total_en
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .appPrimaryColor
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "loading..."
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .appPrimaryColor
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
        backgroundColor = .appBackgroundColor
        
        addSubview(whiteView)
        whiteView.fillSuperview(padding: UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15))
        
        let firstStack = UIStackView(arrangedSubviews: [subtotalTitleLabel, subtotalLabel])
        firstStack.alignment = .center
        firstStack.distribution = .equalCentering

        let secondStack = UIStackView(arrangedSubviews: [deliveryChargesTitleLabel, deliveryChargesLabel])
        secondStack.alignment = .center
        secondStack.distribution = .equalCentering
        
        let thirdStack = UIStackView(arrangedSubviews: [codeAppliedTitleLabel, codeAppliedLabel])
        thirdStack.alignment = .center
        thirdStack.distribution = .equalCentering
        
        let fourthStack = UIStackView(arrangedSubviews: [discountTitleLabel, discountLabel])
        fourthStack.alignment = .center
        fourthStack.distribution = .equalCentering
        
        let fifthStack = UIStackView(arrangedSubviews: [totalTitleLabel, totalLabel])
        fifthStack.alignment = .center
        fifthStack.distribution = .equalCentering
        
        let mainStack = UIStackView(arrangedSubviews: [firstStack, secondStack, thirdStack, fourthStack, fifthStack])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually
        
        whiteView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}

