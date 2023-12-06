//
//  SearchUserProductsVC.swift
//  Zeed
//
//  Created by Mohak Parmar on 18/03/23.
//

import UIKit

class SearchUserProductsVC: UIViewController {
    
    var uId: String = ""
    
    var isLowTohigh : Bool = true
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    //MARK: - Properties
    var searchText: String = "" {
        didSet {
            self.getTheData()
        }
    }
    
    
    func getTheData() {
        self.allPosts.removeAll()
        Service.shared.getAllPosts(byKeyword: searchText, userId: uId, isHighLow: self.isLowTohigh) { (posts, status, message) in
            if status {
                guard let posts = posts else { return }
                self.allPosts.removeAll()
                self.allPosts = posts
            }
        }
    }
    
    var allPosts = [PostItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: sortButton)]

        title = appDele!.isForArabic ? Products_ar : Products_en
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(SearchProductResultsCell.self, forCellWithReuseIdentifier: SearchProductResultsCell.reuseIdentifier)
        
        txtSearch.setBorder(colour: "007DA5", alpha: 1, radius: 20, borderWidth: 1)
        searchText = ""
        
        if appDele!.isForArabic {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
            
    }
    
    
    @IBAction func valueEditingChange(_ sender: Any) {
        searchText = txtSearch.text ?? ""
    }
    
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "sort_ascending"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(sortItemClick), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    
    //MARK: - Selectors
    @objc func sortItemClick() {
        isLowTohigh = !isLowTohigh
        sortButton.setImage(#imageLiteral(resourceName: isLowTohigh ? "sort_ascending" : "sort_decending"), for: .normal)
        self.getTheData()

    }

}

extension SearchUserProductsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchProductResultsCell.reuseIdentifier, for: indexPath) as! SearchProductResultsCell
        cell.post = allPosts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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


extension SearchUserProductsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .search {
            self.view.endEditing(true)
            searchText = txtSearch.text ?? ""
        }
        return true
    }
}
