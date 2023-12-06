//
//  AuctionDurationPicker.swift
//  Zeed
//
//  Created by Shrey Gupta on 23/08/21.
//

import UIKit

enum AuctionDuration: String, CaseIterable {
    case oneHour = "1 Hour"
    case twoHour = "2 Hours"
    case twelveHour = "12 Hours"
    case twentyfourHour = "24 Hours"
    case twoDays = "2 Days"
    case threeDays = "3 Days"
    case fourDays = "4 Days"
    case fiveDays = "5 Days"
    
    var timeInMinutes: Int {
        switch self {
        case .oneHour:
            return 60
        case .twoHour:
            return 60*2
        case .twelveHour:
            return 60*12
        case .twentyfourHour:
            return 60*24
        case .twoDays:
            return 60*24*2
        case .threeDays:
            return 60*24*3
        case .fourDays:
            return 60*24*4
        case .fiveDays:
            return 60*24*5
        }
    }
}

protocol AuctionDurationPickerDelegate: AnyObject {
    func auctionDurationPicker(_ AuctionDurationPicker: AuctionDurationPicker, didSelectDuration duration: AuctionDuration)
}


class AuctionDurationPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Properties
    var collectionView: UICollectionView
    
    weak var delegate: AuctionDurationPickerDelegate?
    
    //MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Auction Duration"
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
        
        collectionView.register(AuctionDurationPickerCell.self, forCellWithReuseIdentifier: AuctionDurationPickerCell.reuseIdentifier)
        
        
        
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
    }
    
    //MARK: - DataSource UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AuctionDuration.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AuctionDurationPickerCell.reuseIdentifier, for: indexPath) as! AuctionDurationPickerCell
        cell.duration = AuctionDuration.allCases[indexPath.row]
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
        delegate?.auctionDurationPicker(self, didSelectDuration: AuctionDuration.allCases[indexPath.row])
    }
}



