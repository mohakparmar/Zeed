//
//  CreatePhotosCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

protocol CreatePhotosCellDelegate: AnyObject {
    func didAddImage()
    func didDeleteImage(image: UIImage)
}


class CreatePhotosCell: UICollectionViewCell {
    //MARK: - Properties
    
    weak var delegate: CreatePhotosCellDelegate?
    
    var image: UIImage? {
        didSet {
            addImageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            removeImageButton.alpha = 1
        }
    }
    
    //MARK: - UI Elements
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add_image").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddImageTapped), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var removeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        
        button.titleLabel?.centerX(inView: button)
        button.titleLabel?.centerY(inView: button)
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.appPrimaryColor
        button.setDimensions(height: 15, width: 15)
        button.layer.cornerRadius = 15/2
        
        button.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        addImageButton.setImage(#imageLiteral(resourceName: "add_image").withRenderingMode(.alwaysOriginal), for: .normal)
        removeImageButton.alpha = 0
    }
    
    //MARK: - Selectors
    
    @objc func handleAddImageTapped() {
        delegate?.didAddImage()
    }
    
    @objc func removeImage() {
        guard let image = self.image else { return }
        delegate?.didDeleteImage(image: image)
        self.image = nil
    }
    
    //MARK: - Helper Functions
    
    func configureCell() {
        addSubview(addImageButton)
        addImageButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        addSubview(removeImageButton)
        removeImageButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: (frame.width/4) - 15, paddingRight: (frame.width/4) - 15)
        removeImageButton.alpha = 0
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}



