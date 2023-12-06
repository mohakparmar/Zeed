//
//  BiddingWonController.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class BiddingWonController: UIViewController {
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
        
        title = appDele!.isForArabic ? Won_ar : Won_en
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(BiddingWonCell.self, forCellWithReuseIdentifier: BiddingWonCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "Won_Bidding", str_nib_name: self.nibName ?? "")

        fetchAllItems()
        configureUI()
    }
    
    //MARK: - Selectors
    
    //MARK: - API
    func fetchAllItems() {
        Service.shared.fetchMyBiddings(ofType: .won) { status, allItems, message in
            if status {
                guard let allItems = allItems else { return }
                self.myBiddingItems = allItems
            } else {
                guard let message = message else { return }
                Utility.showISMessage(str_title: "Failed to fetch won biddings.", Message: message, msgtype: .error)
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


extension BiddingWonController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBiddingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BiddingWonCell.reuseIdentifier, for: indexPath) as! BiddingWonCell
        cell.myBidding = myBiddingItems[indexPath.row]
        cell.btnPurchaseClick = {
            var postItem = BidItem(dict: [:])
            postItem.id = cell.myBidding?.id ?? ""
            postItem.location = cell.myBidding?.location ?? ""
            postItem.about = cell.myBidding?.about ?? ""
            postItem.title = cell.myBidding?.title ?? ""
            postItem.biddingStatistics = cell.myBidding!.biddingStatistics
            postItem.commentCount = cell.myBidding!.commentCount
            postItem.creationDate = cell.myBidding!.creationDate
            postItem.countRegistrationUsers = cell.myBidding!.countRegistrationUsers
            postItem.currentBid = cell.myBidding!.currentBid
            postItem.displayStatus =  BidItemStatus(rawValue: cell.myBidding!.displayStatus) ?? .ongoing
            postItem.endingPrice = cell.myBidding!.endingPrice
            postItem.hasPaidRegistrationPrice = cell.myBidding!.hasPaidRegistrationPrice
            postItem.initialPrice = cell.myBidding!.initialPrice
            postItem.isActive = cell.myBidding!.isActive
            postItem.isLiked = cell.myBidding!.isLiked
            postItem.isReported = cell.myBidding!.isReported
            postItem.likeCount = cell.myBidding!.likeCount
            postItem.medias = cell.myBidding!.medias
            postItem.minPostIncrementPrice = cell.myBidding!.minPostIncrementPrice
            postItem.owner = cell.myBidding!.owner
            postItem.postBaseType = cell.myBidding!.postBaseType
            postItem.registrationAmount = cell.myBidding!.registrationAmount
            postItem.reportCount = cell.myBidding!.reportCount
            postItem.startDate = cell.myBidding!.startDate
            postItem.status = cell.myBidding!.status
            postItem.type = cell.myBidding!.type
            postItem.viewCount = cell.myBidding!.viewCount
            postItem.endDate = cell.myBidding!.endDate

            let controller = BiddingPayController(forBidItem: postItem)
            controller.isForBiddingPay = true
            self.navigationController?.pushViewController(controller, animated: true)

        }
        return cell
    }
}

extension BiddingWonController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

