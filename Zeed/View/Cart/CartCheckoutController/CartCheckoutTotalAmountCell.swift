//
//  CartCheckoutTotalAmountCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 08/04/21.
//

import UIKit
import MFSDK

protocol CartCheckoutTotalAmountCellDelegate: class {
    func didPressPay()
}
class CartCheckoutTotalAmountCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CartCheckoutTotalAmountCellDelegate?
    
    var totalAmount: Double? {
        didSet {
            guard let totalAmount = totalAmount else { return }
            totalAmountLabel.text = "\(totalAmount) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            totalAmountLabel.text = String(format: "%.3f %@", totalAmount, appDele!.isForArabic ? KWD_ar : KWD_en)

        }
    }
    //MARK: - Elements
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Total_ar : Total_en
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "loading..."
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBrightBlueColor
        button.setTitle(appDele!.isForArabic ? Pay_ar : Pay_en, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handlePay), for: .touchUpInside)
        
        return button
    }()
    
    private let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.addShadow()
        return view
    }()

    var applePayButton: MFApplePayButton = {
        let view = MFApplePayButton()
//        view.isHidden = true
        return view
    }()

    var mainStack: UIStackView!
    var appleStack: UIView!

    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handlePay() {
        delegate?.didPressPay()
    }
    
    func showApplePayButton(isShow: Bool) {
        if isShow == true {
            appleStack.isHidden = false
            mainStack.isHidden = true
        } else {
            appleStack.isHidden = true
            mainStack.isHidden = false
        }
        applePayButton.fillSuperview()

    }
    
    //MARK: - Helper Functions
    func configureView() {
        backgroundColor = .appBackgroundColor
              
        contentView.addSubview(whiteView)
        whiteView.fillSuperview(padding: UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15))
        
        let detailStack = UIStackView(arrangedSubviews: [totalLabel, totalAmountLabel])
        detailStack.axis = .vertical
        detailStack.alignment = .leading
        detailStack.distribution = .fillProportionally
        
        payButton.setDimensions(height: 50, width: 120)
        
        mainStack = UIStackView(arrangedSubviews: [detailStack, payButton])
        mainStack.alignment = .center
        mainStack.distribution = .equalCentering
        
        whiteView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        
        
        appleStack = UIView()
        applePayButton.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        appleStack.addSubview(applePayButton)
        appleStack.isHidden = true
        appleStack.backgroundColor = UIColor(red: 22 / 255, green: 21 / 255, blue: 21 / 255, alpha: 1)
        appleStack.setRadius(radius: 10)
        whiteView.addSubview(appleStack)
        
        applePayButton.setHeightPosition(heightValue: 100)
        applePayButton.frame = whiteView.frame
        whiteView.addSubview(appleStack)
        whiteView.bringSubviewToFront(appleStack)
        
        appleStack.fillSuperview(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        applePayButton.anchor(top: topAnchor, paddingTop: 30)
        
        print(applePayButton.height)
        print(appleStack.height)

        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
