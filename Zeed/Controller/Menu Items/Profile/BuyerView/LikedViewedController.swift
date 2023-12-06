//
//  LikedViewedController.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//
import UIKit
import SquareFlowLayout

enum LikedViewedType: String {
    case liked = "Liked"
    case viewed = "Viewed"
}

class LikedViewedController: UICollectionViewController {
    //MARK: - Properties
    let type: LikedViewedType
    
    var allitems = [Any]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - UI Elements
    
    
    //MARK: - Lifecycle
    init(type: LikedViewedType) {
        self.type = type
        
        let layout = SquareFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        
        if type.rawValue == "Liked" {
            title = appDele!.isForArabic ? Liked_ar : Liked_en
        } else {
            title = appDele!.isForArabic ? Viewed_ar : Viewed_en
        }
        
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: ExploreCell.reuseIdentifier)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        Utility.openScreenView(str_screen_name: "Liked_Viewed", str_nib_name: self.nibName ?? "")

        setupToHideKeyboardOnTapOnView()
        
        fetchPosts()
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
    
    //MARK: - APIs
    
    func fetchPosts() {
        switch type {
        case .liked:
            Service.shared.fetchLikedPosts { status, allItems, message in
                if status {
                    guard let allItems = allItems else { return }
                    self.allitems = allItems
                } else {
                    guard let message = message else { return }
                    self.showAlert(withMsg: "Failed Liked Posts: \(message)")
                }
            }
        case .viewed:
            Service.shared.fetchViewedPosts { status, allItems, message in
                if status {
                    guard let allItems = allItems else { return }
                    self.allitems = allItems
                } else {
                    guard let message = message else { return }
                    self.showAlert(withMsg: "Failed Viewed Posts: \(message)")
                }
            }
        }
        
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .backgroundWhiteColor
    }
    
    //MARK: - DataSource UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allitems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCell.reuseIdentifier, for: indexPath) as! ExploreCell
        
        let item = allitems[indexPath.row]
        
        if let item = item as? PostItem {
            cell.post = item
            cell.bid = nil
        } else if let item = item as? BidItem {
            cell.bid = item
            cell.post = nil
        }
        
        return cell
    }
    
    //MARK: - Delegate UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = allitems[indexPath.row]
        
        if let item = item as? PostItem {
            navigationController?.pushViewController(SinglePostController(forPost: item, isForSingleItem: true), animated: true)
        } else if let item = item as? BidItem {
            let controller = BiddingController(isForSingleItem: true)
            controller.allBidItems.append(item)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

