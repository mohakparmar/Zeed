//
//  UserProfileStatsCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit

enum UserProfileStatsCellTypes: Int, CaseIterable {
    case followers
    case following
    case products
    case auctions
    
    var description: String {
        switch self {
        case .followers:
            return appDele!.isForArabic ? Followers_ar : Followers_en
        case .following:
            return appDele!.isForArabic ? Following_ar : Following_en
        case .products:
            return appDele!.isForArabic ? Products_ar : Products_en
        case .auctions:
            return appDele!.isForArabic ? Auctions_ar : Auctions_en
        }
    }

    var text: String {
        switch self {
        case .followers:
            return "follower"
        case .following:
            return "following"
        case .products:
            return "product"
        case .auctions:
            return "auction"
        }
    }

}

protocol UserProfileStatsContainerCellDelegate: AnyObject {
    func didTapProfileStatsOf(_ type: UserProfileStatsCellTypes)
}

class UserProfileStatsContainerCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: UserProfileStatsContainerCellDelegate?
    
    var user: User? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var collectionView: UICollectionView
    
    //MARK: - UI Elements
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UserProfileStatsCell.self, forCellWithReuseIdentifier: UserProfileStatsCell.reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        collectionView.backgroundColor = .appBackgroundColor
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        collectionView.fillSuperview()
    }
}

extension UserProfileStatsContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserProfileStatsCellTypes.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = UserProfileStatsCellTypes(rawValue: indexPath.row)!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileStatsCell.reuseIdentifier, for: indexPath) as! UserProfileStatsCell
        cell.user = user
        cell.type = cellType
        return cell
    }
}

extension UserProfileStatsContainerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = (frame.width/4) * 4
        let totalSpacingWidth = CGFloat(0)
        
        let leftInset = (frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = UserProfileStatsCellTypes(rawValue: indexPath.row)!
        delegate?.didTapProfileStatsOf(type)
    }
}
