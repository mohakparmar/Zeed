//
//  NewXYZCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 23/08/21.
//

import UIKit

protocol AddVariantCellDelegate: AnyObject {
    func didTapVariantOne(onCell cell: AddVariantCell)
    func didTapVariantTwo(onCell cell: AddVariantCell)
    func didChangePrice(price: Double, onCell cell: AddVariantCell)
    func didChangeQuantity(quantity: Int, onCell cell: AddVariantCell)
    func didTapRemove(onCell cell: AddVariantCell)
}

class AddVariantCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: AddVariantCellDelegate?
    
    var createVariant: CreateItemVariant? = nil {
        didSet {
            guard let createVariant = createVariant else { return }
            
            if let variantOne = createVariant.getVariantOne() {
                if let selectedOption = variantOne.selectedOption {
                    variantOneTextView.placeholder = variantOne.name
                    variantOneTextView.text = selectedOption.name
                }
            }
            
            if let variantTwo = createVariant.getVariantTwo() {
                if let selectedOption = variantTwo.selectedOption {
                    variantTwoTextView.placeholder = variantTwo.name
                    variantTwoTextView.text = selectedOption.name
                }
            }

            
            priceTextField.text = String(createVariant.getPrice())
            quantityTextField.text = String(createVariant.getQuantity())
        }
    }
    
    //MARK: - UI Elements
    private let variantOneTextView: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = appDele!.isForArabic ? Variant_1_ar : Variant_1_en
        tf.isUserInteractionEnabled = false
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.placeholderFontScale = 1
        tf.anchor(height: 50)
        return tf
    }()
    
    private let variantTwoTextView: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = appDele!.isForArabic ? Variant_2_ar : Variant_2_en
        tf.isUserInteractionEnabled = false
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.placeholderFontScale = 1
        tf.anchor(height: 50)
        return tf
    }()
    
    private lazy var variantOnePlaceholderButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(handleVariantOneTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var variantTwoPlaceholderButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(handleVariantTwoTapped), for: .touchUpInside)
        return button
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var priceTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(didChangePrice), for: .editingDidEnd)
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private let priceCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? KWD_ar : KWD_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let quantityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Quantity_Available_ar : Quantity_Available_en
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var quantityTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(didChangeQuantity), for: .editingDidEnd)
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Remove_ar : Remove_en, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(handleRemoveTapped), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    override func prepareForReuse() {
        variantOneTextView.placeholder = appDele!.isForArabic ? Variant_1_ar : Variant_1_en
        variantOneTextView.text?.removeAll()
        
        
        variantTwoTextView.placeholder = appDele!.isForArabic ? Variant_2_ar : Variant_2_en
        variantTwoTextView.text?.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleVariantOneTapped() {
        delegate?.didTapVariantOne(onCell: self)
    }
    
    @objc func handleVariantTwoTapped() {
        delegate?.didTapVariantTwo(onCell: self)
    }
    
    @objc func didChangePrice() {
        guard let stringPrice = priceTextField.text else { return }
        guard let price = Double(stringPrice) else { return }
        delegate?.didChangePrice(price: price, onCell: self)
    }
    
    @objc func didChangeQuantity() {
        guard let stringQuantity = quantityTextField.text else { return }
        guard let quantity = Int(stringQuantity) else { return }
        delegate?.didChangeQuantity(quantity: quantity, onCell: self)
    }
    
    @objc func handleRemoveTapped() {
        delegate?.didTapRemove(onCell: self)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = 8
        addShadow()
        
        let variantStack = UIStackView(arrangedSubviews: [variantOneTextView, variantTwoTextView])
        variantStack.alignment = .fill
        variantStack.distribution = .fillEqually
        variantStack.spacing = 8
        variantStack.anchor(width: frame.width - 30, height: 50)
        
        let variantPlaceholderButtonStack = UIStackView(arrangedSubviews: [variantOnePlaceholderButton, variantTwoPlaceholderButton])
        variantPlaceholderButtonStack.alignment = .fill
        variantPlaceholderButtonStack.distribution = .fillEqually
        variantPlaceholderButtonStack.spacing = 8
        variantPlaceholderButtonStack.anchor(width: frame.width - 30, height: 50)
        
        priceTextField.anchor(width: 70, height: 33)
        priceCurrencyLabel.anchor(width: 45)
        let priceHSV = UIStackView(arrangedSubviews: [priceTextField, priceCurrencyLabel])
        priceHSV.alignment = .center
        priceHSV.distribution = .fillProportionally
        priceHSV.spacing = 8
        priceHSV.anchor(height: 40)
        
        let priceVSV = UIStackView(arrangedSubviews: [priceTitleLabel, priceHSV])
        priceVSV.axis = .vertical
        priceVSV.alignment = .leading
        priceVSV.distribution = .fillProportionally
        priceVSV.anchor(width: frame.width - 30)
        
        quantityTextField.anchor(width: 70, height: 33)
        let quantityVSV = UIStackView(arrangedSubviews: [quantityTitleLabel, quantityTextField])
        quantityVSV.axis = .vertical
        quantityVSV.alignment = .leading
        quantityVSV.distribution = .fillProportionally
        quantityVSV.anchor(width: frame.width - 30)
        
        let mainStack = UIStackView(arrangedSubviews: [variantStack, priceVSV, quantityVSV])
        mainStack.axis = .vertical
        mainStack.alignment = .leading
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 5
        mainStack.anchor(width: frame.width - 30)
        
        contentView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        
        contentView.addSubview(variantPlaceholderButtonStack)
        variantPlaceholderButtonStack.anchor(top: variantStack.topAnchor, left: variantStack.leftAnchor, bottom: variantStack.bottomAnchor, right: variantStack.rightAnchor)

        
        
        let priceSeperatorView = UIView()
        priceSeperatorView.backgroundColor = .lightGray
        
        addSubview(priceSeperatorView)
        priceSeperatorView.anchor(left: priceTextField.leftAnchor, bottom: priceTextField.bottomAnchor, right: priceTextField.rightAnchor, height: 1)
        
        let quantitySeperatorView = UIView()
        quantitySeperatorView.backgroundColor = .lightGray
        
        addSubview(quantitySeperatorView)
        quantitySeperatorView.anchor(left: quantityTextField.leftAnchor, bottom: quantityTextField.bottomAnchor, right: quantityTextField.rightAnchor, height: 1)
        
        
        contentView.addSubview(removeButton)
        removeButton.centerY(inView: quantityTextField)
        removeButton.anchor(right: mainStack.rightAnchor)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

//        
//        priceHSV.backgroundColor = .random
//        priceTitleLabel.backgroundColor = .random
//        quantityTitleLabel.backgroundColor = .random
//        quantityTextField.backgroundColor = .random
//        variantOneTextView.backgroundColor = .random
//        variantTwoTextView.backgroundColor = .random
        
    }
}
