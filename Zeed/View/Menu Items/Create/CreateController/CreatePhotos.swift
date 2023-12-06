//
//  CreatePhotosCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

protocol CreatePhotosDelegate: class {
    func didAddImage()
    func didDeleteImage(image: UIImage)
}

class CreatePhotos: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CreatePhotosDelegate?
    
    var itemImages = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var collectionView: UICollectionView!
    
    //MARK: - UI Elements
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(CreatePhotosCell.self, forCellWithReuseIdentifier: CreatePhotosCell.reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .appBackgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helper Functions
    
    func configureUI() {
     
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }
    }
}

//MARK: - DataSource UICollectionViewDataSource
extension CreatePhotos: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatePhotosCell.reuseIdentifier, for: indexPath) as! CreatePhotosCell
        
        if indexPath.row < itemImages.count {
            cell.image = itemImages[indexPath.row]
        }
        
        cell.delegate = self
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegateFlowLayout
extension CreatePhotos: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // FIXME: - add select photo
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

//MARK: - Delegate CreatePhotosCellDelegate
extension CreatePhotos: CreatePhotosCellDelegate {
    func didAddImage() {
        delegate?.didAddImage()
    }
    
    func didDeleteImage(image: UIImage) {
        delegate?.didDeleteImage(image: image)
    }
}

