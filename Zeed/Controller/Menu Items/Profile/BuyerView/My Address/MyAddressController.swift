//
//  MyAddressController.swift
//  Fortune
//
//  Created by Shrey Gupta on 29/12/20.
//

import UIKit

class MyAddressController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties
    var allAddresses = [Address]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var rootController: CartCheckoutController?

    //MARK: - UI Elements
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.appPrimaryColor
        button.setTitle("ADD", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()
    
    
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

        view.backgroundColor = .appPrimaryColor
        
        self.edgesForExtendedLayout = []
        Utility.openScreenView(str_screen_name: "My_Address", str_nib_name: self.nibName ?? "")

        collectionView.backgroundColor = .backgroundWhiteColor
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView!.register(AddressCell.self, forCellWithReuseIdentifier: AddressCell.reuseIdentifier)
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAddress()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        })
    }
    
    //MARK: - Selectors
    @objc func handleAdd() {
        let controller = AddAddressVC()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - API
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
        view.addSubview(addButton)
        addButton.anchor(top: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.frame.width, height: 50)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: addButton.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCell.reuseIdentifier, for: indexPath) as! AddressCell
        cell.delegate = self
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
        if rootController != nil {
            let selectedAddress = allAddresses[indexPath.row]
            rootController?.selectedAddress = selectedAddress
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MyAddressController: AddressCellDelegate {
    func didTapEdit(for address: Address) {
        let controller = AddAddressController(editAddress: address)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func didTapDelete(for address: Address) {
        let alert = UIAlertController(title: "Delete Address?", message: "Are you sure you want to delete this address?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { _ in
            Service.shared.deleteAddress(withAddressId: address.id) { status in
                if status {
                    Utility.showISMessage(str_title: "Success!", Message: "Address deleted Successfully!", msgtype: .success)
                } else {
                    Utility.showISMessage(str_title: "Failed!", Message: "Failed to delete Address", msgtype: .error)
                }
                self.fetchAddress()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    }
}
