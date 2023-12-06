//
//  FeedItemImageCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/03/21.
//

import UIKit

class SGImagePagingCell: UICollectionViewCell {
    //MARK: - Properties
    
    //MARK: - UI Elements
    lazy var itemImageView: CustomImageView = {
        let iv = CustomImageView()
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
