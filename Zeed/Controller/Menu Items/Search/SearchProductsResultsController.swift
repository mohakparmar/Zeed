//
//  SearchProductsResultsController.swift
//  Zeed
//
//  Created by Shrey Gupta on 03/03/21.
//

import UIKit

class SearchProductsResultsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    var isHighLow: Bool = true {
        didSet {
            self.getTheData()
        }
    }
    
    
    //MARK: - Properties
    var searchText: String = "" {
        didSet {
            self.getTheData()
        }
    }
    
    func getTheData() {
        self.allPosts.removeAll()
        Service.shared.getAllPosts(byKeyword: searchText, isHighLow: isHighLow) { (posts, status, message) in
            if status {
                guard let posts = posts else { return }
                self.allPosts.removeAll()
                self.allPosts = posts
            } else {
//                    guard let message = message else { return }
//                    self.showAlert(withMsg: message)
                return
            }
        }
    }
    
    var allPosts = [PostItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(collectionViewLayout: layout)
        title = appDele!.isForArabic ? Products_ar : Products_en
        
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(SearchProductResultsCell.self, forCellWithReuseIdentifier: SearchProductResultsCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Search_Product", str_nib_name: self.nibName ?? "")

        configureUI()
    }
    
    //MARK: - Selector
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .backgroundWhiteColor
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchProductResultsCell.reuseIdentifier, for: indexPath) as! SearchProductResultsCell
        cell.post = allPosts[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = allPosts[indexPath.row]
        let controller = SinglePostController(forPost: post, isForSingleItem: false)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 75)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


