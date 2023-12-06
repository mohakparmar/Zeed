//
//  IGRoundedView.swift
//  IGRoundedView
//
//  Created by Ranjith Kumar on 12/5/17.
//  Copyright © 2017 Dash. All rights reserved.
//

import Foundation
import UIKit

//@note:Recommended Size: CGSize(width:70,height:70)
struct Attributes {
    let borderWidth: CGFloat = 0
    
    let addStoryBorderColor = UIColor.appPrimaryColor
    let borderColor = UIColor.white
    let backgroundIGColor = IGTheme.redOrange
    let backgroundColor = UIColor.appPrimaryColor
    let size = CGSize(width:67,height:67)
}

class IGRoundedView: UIView {
    private var attributes:Attributes = Attributes()
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = (attributes.borderWidth)
        iv.layer.borderColor = attributes.borderColor.cgColor
        iv.clipsToBounds = true
        return iv
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = attributes.backgroundColor
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
        backgroundColor = attributes.backgroundColor
        addSubview(imageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        imageView.frame = CGRect(x: 3.5, y: 3.5, width: (attributes.size.width) - 7, height: attributes.size.height - 7)
        imageView.layer.cornerRadius = imageView.frame.height/2
    }
}

enum IGStoryCellType {
    case live
    case story
}

extension IGRoundedView {
    func enableBorder(enabled: Bool = true, cellType: IGStoryCellType? = .story) {
        if enabled {
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0
        }else {
            layer.borderColor = attributes.borderColor.cgColor
            layer.borderWidth = attributes.borderWidth
            
            if cellType == .live {
                backgroundColor = IGTheme.redOrange
            } else {
                backgroundColor = UIColor.appPrimaryColor
            }
        }
    }
}
