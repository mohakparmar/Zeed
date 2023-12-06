//
//  SearchProductResultsCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit

class SearchProductResultsCell: UICollectionViewCell {
    //MARK: - Properties
    var post: PostItem? {
        didSet {
            guard let post = post else { return }
            itemNameLabel.text = "\(appDele!.isForArabic ? post.title_ar : post.title)"

            storeNameLabel.text = post.owner.storeDetails.shopName
            itemImageView.loadImage(from: post.medias.first?.url ?? "")
            itemPriceLabel.text = String(format: "%.3f %@", post.price,appDele!.isForArabic ? KWD_ar : KWD_en)
        }
        
    }
    //MARK: - UI Elements
    lazy var itemImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .random
        
        iv.setDimensions(height: frame.height - 16, width: frame.height - 16)
        
        return iv
    }()
    
    lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    
    lazy var storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    

    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()

    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        backgroundColor = .backgroundWhiteColor
        
        let nameStoreStack = UIStackView(arrangedSubviews: [itemNameLabel, storeNameLabel])
        nameStoreStack.axis = .vertical
        nameStoreStack.spacing = 4
        nameStoreStack.alignment = .leading
        
        let mainStack = UIStackView(arrangedSubviews: [itemImageView, nameStoreStack, itemPriceLabel])
        mainStack.axis = .horizontal
        mainStack.spacing = 10
        mainStack.alignment = .center
        mainStack.distribution = .fill
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        addSubview(seperatorView)
        seperatorView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 72, height: 1)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }


    }
}

