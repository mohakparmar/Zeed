//
//  NotificationActivitiesController.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit

class NotificationActivitiesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var allNotifications = [GeneralNotification]()
    
    //MARK: - Lifecycle
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(collectionViewLayout: layout)
        
        title = appDele!.isForArabic ? "الأنشطة" : "Activities"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NotificationActivityCell.self, forCellWithReuseIdentifier: NotificationActivityCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNotifications()
        configureUI()
    }
    
    //MARK: - Selector
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .appBackgroundColor
    }
    
    func fetchNotifications() {
        Service.shared.getAllNotification { arr, status, message in
            if status {
                self.allNotifications = arr ?? []
            } else {
                guard let message = message else { return }
//                self.showAlert(withMsg: message)
            }
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Delegate UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allNotifications.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationActivityCell.reuseIdentifier, for: indexPath) as! NotificationActivityCell
        cell.objGeneral = allNotifications[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
