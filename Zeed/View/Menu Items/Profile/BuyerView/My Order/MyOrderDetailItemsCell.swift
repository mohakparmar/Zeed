//
//  MyOrderDetailItemsCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/04/21.
//

import UIKit
import GMStepper
import SwipeCellKit

class MyOrderDetailItemsCell: UICollectionViewCell {
    
    //MARK: - Properties
    var indexPath: IndexPath!
    var itemQty: String = ""
    
    var item: CartItem? {
        didSet {
            guard let item = item else { return }

            itemImageView.loadImage(from: item.medias.first?.url ?? "")
            itemLabel.text = appDele!.isForArabic ? item.title : item.title
//            itemPriceLabel.text = "\(item.totalPrice) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            itemPriceLabel.text = String(format: "%.3f %@", item.price, appDele!.isForArabic ? KWD_ar : KWD_en)
            quantityStepper.value = Double(item.selectedQuantity)
            
            variantLabel.text = nil
            itemQuantity.text = "Quantity : \(item.selectedQuantity)"
            if item.selectedQuantity <= 0 {
                itemQuantity.text = "Quantity : 1"
                itemQuantity.text = "Quantity : \(itemQty)"
            }

            if let variant = item.selectedVariant {
                quantityStepper.maximumValue = Double(variant.quantity)
                
                /// logic for variant info string
                var variantText = ""
                
                guard let variantComboString = item.selectedVariant?.variantComboString else { return }
                let variantComboStringArray = variantComboString.split(separator: "-")
                
                for index in 0 ..< variantComboStringArray.count {
                    variantText += variantComboStringArray[index]
                    variantText += " "
                }
                
                variantLabel.text = variantText
            } else {
                quantityStepper.maximumValue = Double(item.quantityAvailable)
            }
        }
    }
    
    //MARK: - UI Elements
    
    lazy var itemImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.setDimensions(height: frame.height - 20, width: frame.height - 20)
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    private let itemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var variantLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.5, weight: .semibold)
        return label
    }()

    private lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    
    private lazy var itemQuantity: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    
    private lazy var quantityStepper: GMStepper = {
        let stepper = GMStepper()
        stepper.buttonsBackgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        stepper.buttonsTextColor = .white
        
        stepper.labelBackgroundColor = .white
        stepper.labelTextColor = UIColor.lightGray.withAlphaComponent(0.6)
        stepper.labelFont = UIFont(name: "AvenirNext-Bold", size: 19)!
        
        stepper.limitHitAnimationColor = .systemRed
        
        stepper.isEnabled = false
        
        stepper.minimumValue = 1
        stepper.maximumValue = 5
        
        stepper.setDimensions(height: 35, width: 120)
        return stepper
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        congifureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    
    
    //MARK: - Helper Functions
    
    func congifureCell() {
        backgroundColor = .white
        
        let stepperStackSpacing = frame.width - 20 - (frame.height - 20) - 8 - 120 - 35
        
        let stepperDeleteStack = UIStackView(arrangedSubviews: [quantityStepper])
        stepperDeleteStack.axis = .horizontal
        stepperDeleteStack.distribution = .equalSpacing
        stepperDeleteStack.alignment = .center
        stepperDeleteStack.spacing = stepperStackSpacing
        
        let detailsStack = UIStackView(arrangedSubviews: [itemLabel, variantLabel, itemPriceLabel, itemQuantity])
        detailsStack.axis = .vertical
        detailsStack.distribution = .fillProportionally
        detailsStack.alignment = .leading
        detailsStack.spacing = 4
        
        
        let mainStack = UIStackView(arrangedSubviews: [itemImageView, detailsStack])
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 8
        
        contentView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
