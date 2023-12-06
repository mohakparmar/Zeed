//
//  MyAddressVC.swift
//  Zeed
//
//  Created by Mohak Parmar on 22/01/22.
//

import UIKit

class MyAddressVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: title, preferredLargeTitle: false)

        navigationItem.title = appDele!.isForArabic ? Addresses_ar : Addresses_en
        view.backgroundColor = .backgroundWhiteColor
        Utility.openScreenView(str_screen_name: "My_Address", str_nib_name: self.nibName ?? "")


        
        self.edgesForExtendedLayout = .bottom
        collectionAdderess.backgroundColor = .backgroundWhiteColor
        collectionAdderess.register(AddressCell.self, forCellWithReuseIdentifier: AddressCell.reuseIdentifier)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
            btnAddAddress.setTitle(Add_Address_ar, for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        //        if let tabBarFrame = self.tabBarController?.tabBar.frame {
        //            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
        //                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
        //            })
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAddress()
        self.tabBarController?.tabBar.isHidden = true
        

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .appBackgroundColor), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .appPrimaryColor
        self.navigationController?.navigationBar.barTintColor = .appBackgroundColor

        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = UIImage(color: .appBackgroundColor)
            appearance.shadowImage = UIImage()
            appearance.backgroundColor = .appBackgroundColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }

        //        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
        //            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        //        })
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
    
    @IBAction func btnAddAddressClick(_ sender: Any) {
        let controller = AddAddressVC()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
    //MARK: - Properties
    var allAddresses = [Address]() {
        didSet {
            collectionAdderess.reloadData()
        }
    }
    
    var rootController: CartCheckoutController?
    
    @IBOutlet weak var collectionAdderess: UICollectionView!
    @IBOutlet weak var btnAddAddress: UIButton!
    
}


extension MyAddressVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - DataSource UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allAddresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if rootController != nil {
            let selectedAddress = allAddresses[indexPath.row]
            rootController?.selectedAddress = selectedAddress
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension MyAddressVC: AddressCellDelegate {
    func didTapEdit(for address: Address) {
        let controller = AddAddressVC()
        controller.address = address
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func didTapDelete(for address: Address) {
        let alert = UIAlertController(title: appDele!.isForArabic ? Delete_ar : Delete_en, message: appDele!.isForArabic ? Are_you_sure_you_want_to_delete_your_address_ar : Are_you_sure_you_want_to_delete_your_address_en, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Confirm_ar : Confirm_en, style: .destructive, handler: { _ in
            Service.shared.deleteAddress(withAddressId: address.id) { status in
                if status {
                    Utility.showISMessage(str_title: "", Message: "Address deleted Successfully!", msgtype: .success)
                } else {
                    Utility.showISMessage(str_title: "", Message: "Failed to delete Address", msgtype: .error)
                }
                self.fetchAddress()
            }
        }))
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .cancel, handler: nil))
        
    }
}
