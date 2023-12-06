//
//  SearchUserResultsController.swift
//  Zeed
//
//  Created by Shrey Gupta on 03/03/21.
//

import UIKit

class SearchUserResultsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var searchText: String = "" {
        didSet {
            self.allUsers.removeAll()
            Service.shared.getAllUsers(byKeyword: searchText) { (users, status, message) in
                if status {
                    Service.shared.getRequestedList(ofType: .requested) { (requestedUser, reqStatus, reqMessage) in
                        if reqStatus {
                            guard let reqUsers = requestedUser else { return }
                            guard var allUsers = users else { return }
                            
                            if allUsers.count > 0 {
                                reqUsers.forEach { (reqUser) in
                                    for index in 0...allUsers.count - 1 {
                                        if allUsers[index].id == reqUser.id {
                                            allUsers[index].requestStatus = true
                                        }
                                    }
                                }
                            }
                            self.allUsers = allUsers
                        } else {
                        }
                    }
                } else {
                    return
                }
            }
        }
    }
    
    var allUsers = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(collectionViewLayout: layout)
        title = appDele!.isForArabic ?  (Users_ar + "/" + Sellers_ar) : (Users_en + "/" + Sellers_en)
        
        collectionView.delegate = self
        collectionView.register(SearchUserResultsCell.self, forCellWithReuseIdentifier: SearchUserResultsCell.reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        searchText = ""
        Utility.openScreenView(str_screen_name: "Search_User", str_nib_name: self.nibName ?? "")


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
        return allUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchUserResultsCell.reuseIdentifier, for: indexPath) as! SearchUserResultsCell
        cell.user = allUsers[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = allUsers[indexPath.row]
//        let controller = UserProfileController(forUserId: user.id)
        let obj = OtherProfileVC()
        obj.userId = user.id
        navigationController?.pushViewController(obj, animated: true)
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

//MARK: - Delegate SearchUserResultsCellDelegate
extension SearchUserResultsController: SearchUserResultsCellDelegate {
    func didTapFollowButton(button: UIButton, cell: SearchUserResultsCell) {
        guard let user = cell.user else { return }
        if !button.isSelected {
            Service.shared.performAction(ofType: .unfollow, onUser: user) {_ in }
        }
        else {
            Service.shared.performAction(ofType: .follow, onUser: user) {_ in }
        }
    }
}

