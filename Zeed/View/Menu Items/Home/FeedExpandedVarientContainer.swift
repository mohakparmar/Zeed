//
//  FeedExpandedVarientContainer.swift
//  Zeed
//
//  Created by Shrey Gupta on 17/04/21.
//

import UIKit

protocol FeedExpandedVarientContainerDelegate: AnyObject {
    func didSelectOption(updatedAttribute: ItemAttribute, fromContainer container: FeedExpandedVarientContainer)
    func didSelectOptionWithIndex(updatedAttribute: ItemVariant, fromContainer container: FeedExpandedVarientContainer, index:Int)
}

class FeedExpandedVarientContainer: UITableViewCell, UICollectionViewDelegate {
    //MARK: - Properties
    weak var delegate: FeedExpandedVarientContainerDelegate?
    
    var collectionView: UICollectionView
    
    var attribute: [ItemVariant]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    //MARK: - UI Elements
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50), collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FeedExpandedVarientCell.self, forCellWithReuseIdentifier: FeedExpandedVarientCell.reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .white
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceHorizontal = true
        
        
        contentView.addSubview(collectionView)
        collectionView.fillSuperview()
    }
}

//MARK: - DataSource UICollectionViewDataSource
extension FeedExpandedVarientContainer: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attribute?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedExpandedVarientCell.reuseIdentifier, for: indexPath) as! FeedExpandedVarientCell
        cell.title.text = attribute?[indexPath.row].ItemName ?? ""
        
//        if attribute?.selectedOption?.id == attribute?.options[indexPath.row].id {
//            cell.isSelected = true
//        } else {
//            cell.isSelected = false
//        }
        
//        if attribute?.selectedOption?.id == attribute?[indexPath.row].id {
//            cell.backgroundColor = .appPrimaryColor
//            cell.title.textColor = .white
//        } else {
//            cell.backgroundColor = .backgroundWhiteColor
//            cell.title.textColor = .black
//        }

        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: cell)
        }

        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegateFlowLayout
extension FeedExpandedVarientContainer: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: frame.height - 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard attribute != nil else { return }
        self.delegate?.didSelectOptionWithIndex(updatedAttribute: attribute![indexPath.row], fromContainer: self, index: indexPath.row)
        
//        guard attribute != nil else { return }
//        let selectedOption = attribute?.options[indexPath.row]
//        attribute?.selectedOption = selectedOption
//        collectionView.reloadData()
//        
//        delegate?.didSelectOption(updatedAttribute: attribute!, fromContainer: self)
    }
}
