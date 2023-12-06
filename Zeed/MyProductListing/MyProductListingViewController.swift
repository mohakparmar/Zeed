//
//  MyProductListingViewController.swift
//  Zeed
//
//  Created by Mohak Parmar on 26/03/22.
//

import UIKit

class MyProductListingViewController: UIViewController {

    @IBOutlet weak var tblMyProduct: UITableView!
    
    var userPosts = [PostItem]() {
        didSet {
            tblMyProduct.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "My_Package_Listing", str_nib_name: self.nibName ?? "")

        self.navigationItem.title = "My Product"
        tblMyProduct.registerNib(nibName: "MyProductListingTCell")
        fetchUserPosts()
    }

    
    func fetchUserPosts() {
        if let currentUser = AppUser.shared.getDefaultUser() {
            Service.shared.fetchAllPost(userId: currentUser.id, isRandom: false) { items, status, message in
                if status {
                    guard let allItems = items else { return }
                    self.userPosts = allItems
                } else {

                }
            }
        }
    }
    
    func changeTheStatus(objItem : PostItem) {
        Service.shared.updatePostActiveStatus(forPostId: objItem.id, status: objItem.isActive) { isTrue, msg in
            
        }
    }
}


extension MyProductListingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMyProduct.dequeueReusableCell(withIdentifier: "cell") as! MyProductListingTCell
        cell.objItem = userPosts[indexPath.row]
        cell.btnEditClick = {
            let obj = EditProductVariantVC()
            obj.hidesBottomBarWhenPushed = true
            obj.objItem = self.userPosts[indexPath.row]
            self.navigationController?.pushViewController(obj, animated: true)
        }
        
        cell.switchValueChange = {
            self.userPosts[indexPath.row].isActive = cell.switchOnOff.isOn
            self.changeTheStatus(objItem: self.userPosts[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
