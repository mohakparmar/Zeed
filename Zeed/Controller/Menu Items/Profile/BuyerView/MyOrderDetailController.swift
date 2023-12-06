//
//  MyOrderDetailController.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/04/21.
//

import UIKit

enum MyOrderDetailSections: Int, CaseIterable {
    case status
    case summary
    case address
    case items
    
    var cellHeight: CGFloat {
        switch self {
        case .status:
            return 350
        case .summary:
            return 215
        case .address:
            return 170
        case .items:
            return 500
        }
    }
}

class MyOrderDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var orderItem: OrderItem
    
    //MARK: - Lifecycle
    
    init(forOrderItem item: OrderItem) {
        self.orderItem = item
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        
        navigationItem.title = appDele!.isForArabic ? Order_Summary_ar : Order_Summary_en 
        
        collectionView.delegate = self
        
        collectionView.register(MyOrderDetailStatusCell.self, forCellWithReuseIdentifier: MyOrderDetailStatusCell.reuseIdentifier)
        collectionView.register(MyOrderDetailSummaryCell.self, forCellWithReuseIdentifier: MyOrderDetailSummaryCell.reuseIdentifier)
        collectionView.register(MyOrderDetailAddressCell.self, forCellWithReuseIdentifier: MyOrderDetailAddressCell.reuseIdentifier)
        collectionView.register(MyOrderDetailItemsContainer.self, forCellWithReuseIdentifier: MyOrderDetailItemsContainer.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "My_Order_Details", str_nib_name: self.nibName ?? "")

        fetchOrderDetails()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        })
    }
    
    //MARK: - API
    func fetchOrderDetails() {
        
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .appBackgroundColor
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
    }
    
    //MARK: - DataSource & Delegate UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyOrderDetailSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType = MyOrderDetailSections.allCases[indexPath.row]
         
        if cellType == .items {
            return CGSize(width: view.frame.width - 30, height: CGFloat(Float(45 + (orderItem.items.count * 130))))
        }
        
        return CGSize(width: view.frame.width - 30, height: cellType.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = MyOrderDetailSections.allCases[indexPath.row]
        
        switch cellType {
        case .status:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOrderDetailStatusCell.reuseIdentifier, for: indexPath) as! MyOrderDetailStatusCell
            cell.orderItem = orderItem
            return cell
        case .summary:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOrderDetailSummaryCell.reuseIdentifier, for: indexPath) as! MyOrderDetailSummaryCell
            cell.orderItem = orderItem
            return cell
        case .address:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOrderDetailAddressCell.reuseIdentifier, for: indexPath) as! MyOrderDetailAddressCell
            cell.orderItem = orderItem
            return cell
        case .items:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOrderDetailItemsContainer.reuseIdentifier, for: indexPath) as! MyOrderDetailItemsContainer
            cell.items = orderItem.items
            cell.itemQty = "\(self.orderItem.totalItems)"
            return cell
        }
    }
}


