//
//  BecomeSellerTnCCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 13/09/21.
//

import UIKit

protocol BecomeSellerTnCCellDelegate: AnyObject {
    func didTapTnC(isAgreed: Bool)
    func didtapOnLabel()
}

class BecomeSellerTnCCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: BecomeSellerTnCCellDelegate?
    
    //MARK: - UI Elements
    private lazy var checkBoxButton: CheckBox = {
        let checkBox = CheckBox(type: .system)
        checkBox.isChecked = false
        checkBox.tintColor = .darkGray
        checkBox.addTarget(self, action: #selector(handleCheckboxTapped), for: .touchUpInside)
        checkBox.alpha = 0.9
        return checkBox
    }()
    
    private let tncLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Accept_Terms_and_Conditions_ar : Accept_Terms_and_Conditions_en
        label.textColor = .darkGray
        label.alpha = 0.9
        label.isUserInteractionEnabled = true
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
    @objc func handleCheckboxTapped(sender: UIButton) {
        checkBoxButton.buttonClicked(sender: sender)
        delegate?.didTapTnC(isAgreed: checkBoxButton.isChecked)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        checkBoxButton.setDimensions(height: 35, width: 35)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        tncLabel.isUserInteractionEnabled = true
        tncLabel.addGestureRecognizer(tap)

        
        let mainStack = UIStackView(arrangedSubviews: [checkBoxButton, tncLabel])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 8
        mainStack.distribution = .fill
        
        contentView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        delegate?.didtapOnLabel()
    }

}
