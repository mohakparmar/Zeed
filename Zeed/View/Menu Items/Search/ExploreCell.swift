//
//  ExploreCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/03/21.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    //MARK: - Properties
    var post: PostItem? {
        didSet {
            guard let post = post else { return }
            guard let link = post.medias.first?.url else { return }
            galleryImageView.loadImage(from: link)
        }
    }
    
    var bid: BidItem? {
        didSet {
            guard let bid = bid else { return }
            guard let link = bid.medias.first?.url else { return }
            galleryImageView.loadImage(from: link)
        }
    }
    
    //MARK: - UI Elements
    lazy var galleryImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .random
        return iv
    }()
    
    //MARK: - UI Elements
    lazy var hiddenImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.frame = CGRect(x: self.frame.size.width - 40, y: 10, width: 30, height: 30)
        iv.image = UIImage(named: "hidden")
        return iv
    }()

    //MARK: - UI Elements
    lazy var purchaseImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.frame = CGRect(x: self.frame.size.width - 80, y: 10, width: 30, height: 30)
        iv.image = UIImage(named: "purchased")
        return iv
    }()

    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        galleryImageView.image = nil
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
         addSubview(galleryImageView)
        galleryImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        addSubview(hiddenImg)
        addSubview(purchaseImg)
        hiddenImg.frame = CGRect(x: self.frame.size.width - 40, y: 10, width: 30, height: 30)
        hiddenImg.isHidden = true
        purchaseImg.frame = CGRect(x: self.frame.size.width - 80, y: 10, width: 30, height: 30)
        purchaseImg.isHidden = true
//        if appDele!.isForArabic == true {
//            ConvertArabicViews.init().convertSingleView(toAr: self)
//        }

    }
}
