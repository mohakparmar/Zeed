//
//  SGImageScrollPagingCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 22/04/21.
//

import UIKit
import ImageScrollView

class SGImageScrollPagingCell: UICollectionViewCell {
    //MARK: - Properties
    
    //MARK: - UI Elements
    lazy var itemImageView: ImageScrollView = {
        let iv = ImageScrollView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = false
        return iv
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
        clipsToBounds = false
        addSubview(itemImageView)
        itemImageView.fillSuperview()
    }
}
