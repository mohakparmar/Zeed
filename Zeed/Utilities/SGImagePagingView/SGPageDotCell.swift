//
//  SGPageDotCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/03/21.
//

import UIKit

class SGPageDotCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedDotView.alpha = 1
                unSelectedDotView.alpha = 0
            } else {
                selectedDotView.alpha = 0
                unSelectedDotView.alpha = 1
            }
        }
    }
    
    lazy var selectedDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .appPrimaryColor
        view.setDimensions(height: frame.height, width: frame.height)
        view.layer.cornerRadius = frame.height/2
        return view
    }()
    
    lazy var unSelectedDotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        view.setDimensions(height: frame.height * 0.75, width: frame.height * 0.75)
        view.layer.cornerRadius = (frame.height * 0.75)/2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        
        addSubview(selectedDotView)
        selectedDotView.centerX(inView: self)
        selectedDotView.centerY(inView: self)
        
        addSubview(unSelectedDotView)
        unSelectedDotView.centerX(inView: self)
        unSelectedDotView.centerY(inView: self)
        
        selectedDotView.alpha = 0
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
}
