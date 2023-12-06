//
//  BiddingLostController.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class BiddingLostController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView
    
    var myBiddingItems = [MyBiddingItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        title = appDele!.isForArabic ? Lost_ar : Lost_en
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(BiddingLostCell.self, forCellWithReuseIdentifier: BiddingLostCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "Lost_Bidding", str_nib_name: self.nibName ?? "")

        fetchAllItems()
        configureUI()
    }
    
    //MARK: - Selectors
    
    //MARK: - API
    func fetchAllItems() {
        Service.shared.fetchMyBiddings(ofType: .lost) { status, allItems, message in
            if status {
                guard let allItems = allItems else { return }
                self.myBiddingItems = allItems
            } else {
                guard let message = message else { return }
                Utility.showISMessage(str_title: "Failed to fetch lost biddings.", Message: message, msgtype: .error)
            }
        }
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        collectionView.backgroundColor = .appBackgroundColor
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }

    }
}


extension BiddingLostController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBiddingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BiddingLostCell.reuseIdentifier, for: indexPath) as! BiddingLostCell
        cell.myBidding = self.myBiddingItems[indexPath.row]
        return cell
    }
}

extension BiddingLostController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

