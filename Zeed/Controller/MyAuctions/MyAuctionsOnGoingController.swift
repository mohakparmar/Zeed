//
//  MyAuctionsOnGoingController.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/04/21.
//

import UIKit

class MyAuctionsOnGoingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(collectionViewLayout: layout)
        
        title = "On Going"
        
        collectionView.delegate = self
        collectionView.register(MyAuctionsOnGoingCell.self, forCellWithReuseIdentifier: MyAuctionsOnGoingCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "My_Auctions_Ongoing", str_nib_name: self.nibName ?? "")

        configureUI()
    }
    
    //MARK: - Selector
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .appBackgroundColor
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyAuctionsOnGoingCell.reuseIdentifier, for: indexPath) as! MyAuctionsOnGoingCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - (14*2), height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

