//
//  ForwardMessagePicker.swift
//  Zeed
//
//  Created by Shrey Gupta on 27/04/21.
//

import UIKit

protocol ForwardMessagePickerDelegate: AnyObject {
    func forwardMessagePicker(_ forwardMessagePicker: ForwardMessagePicker, didSelectUser user: User, at indexPath: IndexPath)
}

private let reuseIdentifier = "ForwardMessagePickerCell"

class ForwardMessagePicker: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Properties
    var collectionView: UICollectionView!
    
    weak var delegate: ForwardMessagePickerDelegate?
    var post: PostItem?
    
    var allUsers = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Forward"
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ForwardMessagePickerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 45, paddingLeft: 4, paddingRight: 4)
        
        fetchAllUsers()
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - API
    func fetchAllUsers() {
        
        
        Service.shared.getFollowList(forUser: loggedInUser!, type: .following) { users, status, msg in
            if status {
                guard let allUsers = users else { return }
                self.allUsers = allUsers
            }
        }
//        Service.shared.getAllUsers(byKeyword: "") { (users, status, message) in
//        }
    }
    
    //MARK: - Helper Funtions
    func configureUI() {
        collectionView.backgroundColor = .clear
        backgroundColor = .white
        layer.cornerRadius = 10
        addShadow()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 12)
        titleLabel.centerX(inView: self)
    }
    
    //MARK: - DataSource UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ForwardMessagePickerCell
        cell.user = allUsers[indexPath.row]
        return cell
    }
    
    //MARK: - Delegate UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.width - 15), height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 8, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.forwardMessagePicker(self, didSelectUser: allUsers[indexPath.row], at: indexPath)
    }
}
