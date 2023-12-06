//
//  MyOrderDetailItemsContainer.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/04/21.
//
import UIKit

private let itemReuseIdentifier = "MyOrderDetailItemsCell"

class MyOrderDetailItemsContainer: UICollectionViewCell {
    //MARK: - Properties
    var collectionView: UICollectionView!
    
    var items = [CartItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var itemQty: String = ""
    
    //MARK: - UI Elements
    
    private let orderItemsLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Products_ar : Products_en
        label.textAlignment = appDele!.isForArabic ? .right : .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyOrderDetailItemsCell.self, forCellWithReuseIdentifier: itemReuseIdentifier)
        collectionView.backgroundColor = .white
        
        super.init(frame: frame)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors

    
    //MARK: - Helper Functions
    
    func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = 10
        addShadow()
        
        let orderTextStack = UIStackView(arrangedSubviews: [orderItemsLabel])
        orderTextStack.alignment = .center
        orderTextStack.distribution = .fill
        orderTextStack.axis = .horizontal
        
        addSubview(orderTextStack)
        orderTextStack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 10, paddingRight: 10)
        
        contentView.addSubview(collectionView)
        collectionView.anchor(top: orderTextStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 10)
        if appDele!.isForArabic {
            orderItemsLabel.transform = trnForm_Ar
        }
        
    }
}

//MARK: - DataSource UICollectionViewDataSource

extension MyOrderDetailItemsContainer: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseIdentifier, for: indexPath) as! MyOrderDetailItemsCell
        cell.itemQty = self.itemQty
        cell.item = items[indexPath.row]
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegateFlowLayout

extension MyOrderDetailItemsContainer: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

