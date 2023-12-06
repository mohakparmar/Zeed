//
//  CartCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 20/03/21.
//

import UIKit
import GMStepper
import SwipeCellKit

protocol CartCellDelegate: AnyObject {
    func didUpdateQuantity(quantity: Int, atIndexPath indexPath: IndexPath)
    func removeItem(at indexPath: IndexPath)
}

class CartCell: SwipeCollectionViewCell {
    
    //MARK: - Properties
    weak var cartCelldelegate: CartCellDelegate?
    
    var indexPath: IndexPath!

    var item: CartItem? {
        didSet {
            guard let item = item else { return }

            itemImageView.loadImage(from: item.medias.first?.url ?? "")
            itemLabel.text = String(format: "%@", item.title)
            storeName.text = String(format: "%@", item.storeName)

            itemPriceLabel.text = "\(item.totalPrice) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            itemPriceLabel.text = String(format: "%.3f %@", item.totalPrice, appDele!.isForArabic ? KWD_ar : KWD_en)
            outofstockLabel.isHidden = !item.outOfStock
            quantityStepper.value = Double(item.selectedQuantity)
            
            variantLabel.text = nil
            
            if let variant = item.selectedVariant {
//                quantityStepper.maximumValue = Double(variant.quantity)
                
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
//                quantityStepper.maximumValue = Double(item.quantityAvailable)
            }
            
            print("DEBUG:- quat: \(item.selectedQuantity)")
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
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private let storeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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

    private lazy var outofstockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.5, weight: .semibold)
        label.isHidden = true
        label.textColor = .red
        label.text = "Out Of Stock"
        return label
    }()

    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "trash"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        button.setDimensions(height: 30, width: 30)
        button.tintColor = .red
        return button
    }()
    
    
    private var quantityStepper: GMStepper = {
        let stepper = GMStepper()
        
        stepper.isUserInteractionEnabled = true
        
        stepper.buttonsBackgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.6)
        stepper.buttonsTextColor = .white
        
        stepper.labelBackgroundColor = .white
        stepper.labelTextColor = UIColor.appPrimaryColor.withAlphaComponent(0.6)
        stepper.labelFont = UIFont(name: "AvenirNext-Bold", size: 19)!
        
        stepper.limitHitAnimationColor = .systemRed
        
        stepper.minimumValue = 1
//        stepper.maximumValue = 10
        stepper.stepValue = 1
        
        
        stepper.setDimensions(height: 35, width: 120)
        
        stepper.addTarget(self, action: #selector(CartCell.stepperValueChanged), for: .valueChanged)

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
    
    @objc func removeItem() {
        cartCelldelegate?.removeItem(at: indexPath)
    }
    
    @objc func stepperValueChanged(stepper: GMStepper) {
//    https://github.com/gmertk/GMStepper/issues/48
        if stepper.buttonTapped == "Minus" {
            cartCelldelegate?.didUpdateQuantity(quantity: -1, atIndexPath: indexPath)
        } else if stepper.buttonTapped == "Plus" {
            cartCelldelegate?.didUpdateQuantity(quantity: 1, atIndexPath: indexPath)
        }
    }

    
    //MARK: - Helper Functions
    
    func congifureCell() {
        layer.cornerRadius = 8
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        clipsToBounds = true
        
        backgroundColor = .white
        
        let detailsStack = UIStackView(arrangedSubviews: [itemLabel, storeName, variantLabel, itemPriceLabel, quantityStepper, outofstockLabel])
        detailsStack.axis = .vertical
        detailsStack.distribution = .fillProportionally
        detailsStack.alignment = .leading
        detailsStack.spacing = 4
        
        
        let mainStack = UIStackView(arrangedSubviews: [itemImageView, detailsStack])
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 8
        
        contentView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}


