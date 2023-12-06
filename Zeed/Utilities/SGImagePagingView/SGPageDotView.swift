//
//  SGPageDotView.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/03/21.
//

import UIKit

class SGPageDotView: UIView {
    //MARK: - Properties
    var collectionView: UICollectionView
    var numberOfItems: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            print(selectedIndex)
            collectionView.reloadData()
        }
    }
    
    let dotHeight = 7
    let dotSpacing: CGFloat = 5
    
    //MARK: - Lifecycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: .zero)
        
        collectionView.backgroundColor = .clear
        
        collectionView.register(SGPageDotCell.self, forCellWithReuseIdentifier: SGPageDotCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Function
}

extension SGPageDotView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SGPageDotCell.reuseIdentifier, for: indexPath) as! SGPageDotCell
        print(indexPath.row)
        if selectedIndex == indexPath.row {
            cell.selectedDotView.alpha = 1
            cell.unSelectedDotView.alpha = 0
        } else {
            cell.selectedDotView.alpha = 0
            cell.unSelectedDotView.alpha = 1
        }
        return cell
    }
}

extension SGPageDotView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: dotHeight, height: dotHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return dotSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = dotHeight * numberOfItems
        let totalSpacingWidth = Int(dotSpacing) * (numberOfItems - 1)
        
        let leftInset = (frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
