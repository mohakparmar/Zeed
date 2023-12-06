//
//  ExploreController.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/03/21.
//

import UIKit
import SquareFlowLayout
import JGProgressHUD

class ExploreController: UICollectionViewController {
    //MARK: - Properties
    var hud = JGProgressHUD(style: .dark)
    
    var hasFetchedPosts = false

    var isPriceLowToHigh: Bool = false {
        didSet {
            allPosts = []
            fetchAllPosts()
        }
    }

    var cID : String = ""
    
    //MARK: - UI Elements
    var allPosts = [PostItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let refreshControl = UIRefreshControl()

    //MARK: - Lifecycle
    init() {
        let layout = SquareFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        
        configureUI()
        layout.flowDelegate = self
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: ExploreCell.reuseIdentifier)
        

        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl) // not required when using UITableViewController
        self.collectionView.contentInset = UIEdgeInsets.init(top: 70, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "SearchPost", str_nib_name: self.nibName ?? "")

        
        setupToHideKeyboardOnTapOnView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.allPosts = []
        fetchAllPosts()
    }

    
    //MARK: - API
    func fetchAllPosts() {
        hud.show(in: view, animated: true)
        Service.shared.fetchAllExplorePosts(all: true, isEngaged: true, startRange: self.allPosts.count, categoryId: cID, isPriceLowTohigh: isPriceLowToHigh, isPriceSortNeeded: true) { (allPosts, status, message) in
            self.refreshControl.endRefreshing()
            if status {
                guard let allPosts = allPosts else { return }
                if allPosts.count > 0 {
                    self.allPosts.append(contentsOf: allPosts)
                }
            } else {
//                guard let message = message else { return }
            }
            self.hasFetchedPosts = true
            self.hud.dismiss(animated: true)
        }
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .appBackgroundColor
        collectionView.backgroundColor = .appBackgroundColor
        
        
//        if appDele!.isForArabic == true {
//            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
//        }
    }
    
    //MARK: - DataSource UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCell.reuseIdentifier, for: indexPath) as! ExploreCell
        cell.post = allPosts[indexPath.row]
        if (allPosts.count - 1) == indexPath.item {
            self.fetchAllPosts()
        }
        return cell
    }
    
    //MARK: - Delegate UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = SinglePostController(forPost: allPosts[indexPath.row], isForSingleItem: true)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
//MARK: - Delegate SquareFlowLayout
extension ExploreController: SquareFlowLayoutDelegate {
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        return indexPath.row % 8 == 0
    }
}



