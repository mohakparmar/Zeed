//
//  CartCheckoutSelectAddressController.swift
//  Zeed
//
//  Created by Shrey Gupta on 11/12/21.
//

import UIKit

class CartCheckoutSelectAddressController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var allAddresses = [Address]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var rootController: CartCheckoutController?
    
    //MARK: - Lifecycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        navigationItem.title = "My Addresses"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "CheckOut_Select_Address", str_nib_name: self.nibName ?? "")

        collectionView.backgroundColor = .backgroundWhiteColor
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(CartCheckoutSelectAddressCell.self, forCellWithReuseIdentifier: CartCheckoutSelectAddressCell.reuseIdentifier)
        
        fetchAddress()
        configureUI()
    }
    
    //MARK: - Selectors
    // MARK: - API
    func fetchAddress() {
        Utility.showHud(view: self.view)
        Service.shared.fetchAllAddress { status, allAddress, message in
            Utility.hideHud()
            if status {
                guard let allAddress = allAddress else { return }
                self.allAddresses = allAddress
            } else {
                guard let message = message else { return }
                Utility.showISMessage(str_title: "Unable to fetch Address", Message: message, msgtype: .error)
            }
        }
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .random
        
        
    }
    
    // MARK: - DataSource UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allAddresses.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartCheckoutSelectAddressCell.reuseIdentifier, for: indexPath) as! CartCheckoutSelectAddressCell
        cell.address = allAddresses[indexPath.row]
        return cell
    }
    
    //MARK: - Delegate UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAddress = allAddresses[indexPath.row]
        rootController?.selectedAddress = selectedAddress
        self.dismiss(animated: true, completion: nil)
    }
}
