//
//  FollowResultController.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit
import Alamofire
import Network


enum FollowerFollowingControllerType: String {
    case users = "Users"
    case seller = "Sellers"
    case all = "All"
    
    var getTheName: String {
        switch self {
        case .users:
            return appDele!.isForArabic ? "المستخدمون" : "Users"
        case .seller:
            return appDele!.isForArabic ? "البائعون" : "Sellers"
        case .all:
            return appDele!.isForArabic ? "الكل" : "All"
        }
    }
}

class FollowResultController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    let user: User
    let statsType: UserProfileStatsCellTypes
    let controllerType: FollowerFollowingControllerType
    
    var resultUsers = [User]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    init(forUser user: User, from statsType: UserProfileStatsCellTypes, type controllerType: FollowerFollowingControllerType) {
        self.statsType = statsType
        self.user = user
        self.controllerType = controllerType
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(collectionViewLayout: layout)
        title = controllerType.getTheName
        
        collectionView.delegate = self
        collectionView.register(SearchUserResultsCell.self, forCellWithReuseIdentifier: SearchUserResultsCell.reuseIdentifier)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchResultUsers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Follower_Result", str_nib_name: self.nibName ?? "")

        configureUI()
    }
    
    //MARK: - Selector
    
    //MARK: - API
    func fetchResultUsers() {
        if appDele?.isFollowApiCalls == true {
            return
        }
        appDele?.isFollowApiCalls = true
        self.resultUsers.removeAll()
        Service.shared.getFollowList(forUser: user, type: statsType) { (allUsers, status, message) in
            appDele?.isFollowApiCalls = false
            if status {
                guard let allUsers = allUsers else { return }
                
                allUsers.forEach { (user) in
                    if self.controllerType == .seller {
                        if user.isSeller {
                            self.resultUsers.append(user)
                        }
                    } else if self.controllerType == .users {
                        if !user.isSeller {
                            self.resultUsers.append(user)
                        }
                    } else {
                        self.resultUsers.append(user)
                    }
                }
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: message)
            }
        }
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .backgroundWhiteColor
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchUserResultsCell.reuseIdentifier, for: indexPath) as! SearchUserResultsCell
        cell.user = resultUsers[indexPath.row]
        cell.delegate = self
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: cell)
            cell.usernameLabel.textAlignment = .right
        }
        return cell
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let obj = UserProfileController(forUserId: resultUsers[indexPath.row].id)
        let obj = OtherProfileVC()
        obj.userId = resultUsers[indexPath.row].id
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

extension FollowResultController: SearchUserResultsCellDelegate {
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



