//
//  CategoryPicker.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/03/21.
//

import UIKit

struct CreateItemCategory {
    var name: String
    var description: String
}

protocol CategoryPickerDelegate: AnyObject {
    func categoryPicker(_ categoryPicker: CategoryPicker, didSelectCategory category: ItemCategory, at indexPath: IndexPath)
}


class CategoryPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Properties
    var collectionView: UICollectionView!
    
    weak var delegate: CategoryPickerDelegate?
    
    var allCategories: [ItemCategory]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Select_Category_ar : Select_Category_en
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CategoryPickerCell.self, forCellWithReuseIdentifier: CategoryPickerCell.reuseIdentifier)
        
        
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 45, paddingLeft: 4, paddingRight: 4)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helper Funtions
    func configureUI() {
        collectionView.backgroundColor = .clear
        backgroundColor = .white
        layer.cornerRadius = 10
        addShadow()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 12)
        titleLabel.centerX(inView: self)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self)
        }

    }
    
    //MARK: - DataSource UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryPickerCell.reuseIdentifier, for: indexPath) as! CategoryPickerCell
        cell.category = allCategories?[indexPath.row]
        return cell
    }
    
    //MARK: - Delegate UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.width - 38), height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 8, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.categoryPicker(self, didSelectCategory: allCategories![indexPath.row], at: indexPath)
    }
}


