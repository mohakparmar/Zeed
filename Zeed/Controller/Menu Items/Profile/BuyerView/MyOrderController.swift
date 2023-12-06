//
//  MyOrderController.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class MyOrderController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView
    
    var allOrderItems = [OrderItem]() {
        didSet {
            if allOrderItems.count == 0 {
                noPostsAvailableLabel.alpha = 1
            } else {
                noPostsAvailableLabel.alpha = 0
            }
            collectionView.reloadData()
        }
    }
    //MARK: - Lifecycle
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        title = appDele!.isForArabic ? My_Orders_ar : My_Orders_en
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MyOrderCell.self, forCellWithReuseIdentifier: MyOrderCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "My_Order", str_nib_name: self.nibName ?? "")

        configureUI()
        
        collectionView.alwaysBounceVertical = true
        
        fetchMyOrders()
    }
    
    private let noPostsAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Empty_Order_ar : Empty_Order_en
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    
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
    
    //MARK: - Selectors
    
    //MARK: - API
    func fetchMyOrders() {
        Utility.showHud(view: self.view)
        Service.shared.fetchMyOrders { status, allItems, message in
            Utility.hideHud()
            if status {
                guard let allItems = allItems else { return }
                self.allOrderItems = allItems
            } else {
//                guard let message = message else { return }
//                self.showAlert(withMsg: "Failed Fetching Order Items: \(message)")
            }
        }
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        collectionView.backgroundColor = .appBackgroundColor
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        view.addSubview(noPostsAvailableLabel)
        noPostsAvailableLabel.centerY(inView: collectionView)
        noPostsAvailableLabel.centerX(inView: collectionView)
        

                
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
    }
}


extension MyOrderController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allOrderItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOrderCell.reuseIdentifier, for: indexPath) as! MyOrderCell
        cell.orderItem = allOrderItems[indexPath.row]
        return cell
    }
}

extension MyOrderController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = MyOrderDetailController(forOrderItem: allOrderItems[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}


