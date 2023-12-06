//
//  NotificationRequestsController.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit

class NotificationRequestsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
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
        
        title = appDele!.isForArabic ? "الطلبات" : "Requests"
        
        collectionView.delegate = self
        collectionView.register(NotificationRequestCell.self, forCellWithReuseIdentifier: NotificationRequestCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRequests()
        
        configureUI()
    }
    
    //MARK: - Selector
    
    //MARK: - API
    func fetchRequests() {
        allUsers.removeAll()
        Service.shared.getRequestedList(ofType: .recieved) { (allUsers, status, message) in
            if status {
                guard let allUsers = allUsers else { return }
                self.allUsers = allUsers
            } else {
                guard let message = message else { return }
//                self.showAlert(withMsg: message)
            }
        }
    }
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .appBackgroundColor
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationRequestCell.reuseIdentifier, for: indexPath) as! NotificationRequestCell
        cell.user = allUsers[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 130)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension NotificationRequestsController: NotificationRequestCellDelegate {
    func handleAcceptUser(user: User) {
        Service.shared.performAction(ofType: .accept, onUser: user) { (status) in
            self.showAlert(withMsg: status.description)
        }
        fetchRequests()
    }
    
    func handleRejectUser(user: User) {
        Service.shared.performAction(ofType: .reject, onUser: user) { (status) in
            self.showAlert(withMsg: status.description)
        }
        fetchRequests()
    }
}



