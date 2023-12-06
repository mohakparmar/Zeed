//
//  SelectIntrestViewController.swift
//  Zeed
//
//  Created by Mohak Parmar on 13/01/22.
//

import UIKit

class SelectIntrestViewController: UIViewController {
    
    @IBOutlet weak var collectionIntrest: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    var arrForCategory : [CategoryObject] = []
    var isFromProfile: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
        Utility.openScreenView(str_screen_name: "Select_Interest", str_nib_name: self.nibName ?? "")

        self.title = appDele!.isForArabic ? Interests_ar : Interests_en
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        collectionIntrest.registerNib(nibName: "TextCCell")
    }
    
    override func viewWillLayoutSubviews() {
        btnNext.setRadius(radius: 10)
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        updateUserCategory()
//        let arr = arrForCategory.filter({$0.isSelected == true })
//        if arr.count > 0 {
//            self.updateUserCategory()
//        } else {
//            guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? TabBarController else { return }
//            controller.checkIfTheUserIsLoggedIn()
//            self.dismiss(animated: false, completion: nil)
//        }
    }

    
    func getCategories() {
        WSManage.getDataWithPost(name: WSManage.WSGetCategory, parameters: [:], isPost: true) { isError, dict in
            if isError == false {
                self.arrForCategory = []
                if let arr = dict?["data"] as? [[String:Any]] {
                    for item in arr {
                        self.arrForCategory.append(CategoryObject(dict: item))
                    }
                }
            }
            self.getSelectedInterest()
            self.collectionIntrest.reloadData()
        }
    }

    
    func getSelectedInterest() {
        
        Service.shared.getSelectedInterrest { isStatus, arr, err in
            for item in arr {
                for objCate in self.arrForCategory where item.id == objCate.id {
                    objCate.isSelected = true
                }
            }
            self.collectionIntrest.reloadData()
        }
        
//        WSManage.getDataWithPost(name: WSManage.WSGetSelectedCategory, parameters: [:], isPost: true) { isError, dict in
//            if isError == false {
//                print(dict)
//                if let arr = dict?["data"] as? [[String:Any]] {
//                    for item in arr {
//                        let obj = CategoryObject(dict: item)
//                        for objCate in self.arrForCategory where obj.id == objCate.id {
//                            objCate.isSelected = true
//                        }
//                    }
//                }
//            }
//            self.collectionIntrest.reloadData()
//        }
    }

    
    func updateUserCategory() {
        let arr = arrForCategory.filter({ $0.isSelected == true})
        if arr.count == 0 {
            self.showAlert(withMsg: "Please select any interest.")
            return
        }
        var param : [String:Any] = [:]
        param["categoryId"] = arr.map({$0.id})
        WSManage.getDataWithGetServiceWithParamsJsonRow(name: WSManage.WSForAddInterest, parameters: param, isPost: true) { isError, dict in
            if isError == false {
                DispatchQueue.main.async {
                    if self.isFromProfile == true {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? TabBarController else { return }
                        controller.checkIfTheUserIsLoggedIn()
                        self.dismiss(animated: false, completion: nil)
                        appDele?.isForSearch = true
                        let tabController = appDele?.window?.rootViewController as? TabBarController
                        tabController?.selectedIndex = 1
                    }
                }
            }
        }
    }

}



extension SelectIntrestViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! TextCCell
        let obj = arrForCategory[indexPath.row]
        cell.lblTitle.text = obj.name
        cell.lblTitle.textColor = UIColor().setColor(hex: obj.isSelected ? "FFFFFF" : "000000", alphaValue: 1)
        cell.lblTitle.backgroundColor = UIColor().setColor(hex: obj.isSelected ? "007DA5" : "FFFFFF", alphaValue: 1)
        cell.lblTitle.setBorder(colour: "007DA5", alpha: 1, radius: 22.5, borderWidth: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.arrForCategory[indexPath.row].isSelected = !self.arrForCategory[indexPath.row].isSelected
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10) / 2, height: 45)
    }
    
    
}

class Interest : NSObject {
    
    var name: String = ""
    var isSelected: Bool = false
    
    override init() {
        
    }
    
    class func Cate(name: String) -> Interest {
        let obj = Interest()
        obj.name =  name
        return obj
    }
    
}


