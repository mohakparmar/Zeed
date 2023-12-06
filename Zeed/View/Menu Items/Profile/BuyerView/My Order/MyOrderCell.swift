//
//  MyOrderCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

class MyOrderCell: UICollectionViewCell {
    //MARK: - Properties
    var orderItem: OrderItem? {
        didSet {
            guard let orderItem = orderItem else { return }
            orderNoLabel.text = "\(appDele!.isForArabic ? Order_No_ar : Order_No_en) \(orderItem.invoiceNumber)"
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
            dateLabel.text = dateFormatterGet.string(from: orderItem.createdAt)
            
            statusInfoLabel.text = orderItem.orderStatus.firstCapitalized
            totalProductsInfoLabel.text = "\(orderItem.totalItems)"
            
            if orderItem.orderStatus == "Being Wrapped Up" || orderItem.orderStatus == "Reached at warehouse" || orderItem.orderStatus == "En Route to Warehouse" || orderItem.orderStatus == "Ready for pickup" {
                statusInfoLabel.text = "Being Wrapped Up".firstCapitalized
            }

//            orderAmountInfoLabel.text = "\(orderItem.grandTotal) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            orderAmountInfoLabel.text = String(format: "%.3f %@", orderItem.grandTotal, appDele!.isForArabic ? KWD_ar : KWD_en)
        }
    }
    //MARK: - UI Elements
    private let orderNoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Status_ar : Status_en
        label.textColor = .darkGray
        return label
    }()
    
    private let statusInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .appPrimaryColor
        return label
    }()
    
    private let totalProductsLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Total_Products_ar : Total_Products_en
        label.textColor = .darkGray
        return label
    }()
    
    private let totalProductsInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .appPrimaryColor
        return label
    }()
    
    private let orderAmountLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Total_Amount_ar : Total_Amount_en
        label.textColor = .darkGray
        return label
    }()
    
    private let orderAmountInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .appPrimaryColor
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        layer.cornerRadius = 9
        backgroundColor = .white
        addShadow()
        
        let firstStack = UIStackView(arrangedSubviews: [orderNoLabel, dateLabel])
        firstStack.alignment = .center
        firstStack.distribution = .equalCentering
        
        let secondStack = UIStackView(arrangedSubviews: [statusLabel, statusInfoLabel])
        secondStack.alignment = .center
        secondStack.distribution = .equalCentering
        
        
        let thirdStack = UIStackView(arrangedSubviews: [totalProductsLabel, totalProductsInfoLabel])
        thirdStack.alignment = .center
        thirdStack.distribution = .equalCentering
        
        
        let forthStack = UIStackView(arrangedSubviews: [orderAmountLabel, orderAmountInfoLabel])
        forthStack.alignment = .center
        forthStack.distribution = .equalCentering
        
        let mainStack = UIStackView(arrangedSubviews: [firstStack, secondStack, thirdStack, forthStack])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 18, left: 12, bottom: 18, right: 12))
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
