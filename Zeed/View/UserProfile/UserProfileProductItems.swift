//
//  UserProfileProductItems.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit
import SquareFlowLayout

protocol UserProfileProductItemsDelegate: AnyObject {
    func didSelectProduct(withId id: String, ofType type: PostType, post:PostItem)
    func didselectCategory(withId id: String)
}

class UserProfileProductItems: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    weak var delegate: UserProfileProductItemsDelegate?
    
    var user: User?
    var selectedCategory: ItemSubCategory?
    var allCategories: [ItemSubCategory] = []
    let collectionCategory :UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 50)
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .appBackgroundColor
        return collection
    }()

    var items = [PostItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - UI Elements

    
    //MARK: - Lifecycle
    init() {
        let layout = SquareFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)

        title = appDele!.isForArabic ? Products_ar : Products_en
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: ExploreCell.reuseIdentifier)
        self.collectionView.contentInset = UIEdgeInsets.init(top: 70, left: 0, bottom: 0, right: 0)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "User_Profile", str_nib_name: self.nibName ?? "")

        collectionCategory.delegate = self
        collectionCategory.dataSource = self
        collectionCategory.registerNib(nibName: "CategoryCCell", reUse: "CategoryCCell")

        configureUI()
        setupToHideKeyboardOnTapOnView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("CallCategoryService"), object: nil)

    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.fetchCategories()
    }

    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .backgroundWhiteColor
        self.view.addSubview(collectionCategory)
        collectionView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCategories()
    }
    
    //MARK: - API
    func fetchCategories() {
        Service.shared.getAllSubCategories(isMyProduct:true, userId: user?.id ?? "") { (allCategories, status, message) in
            if status {
                guard let allCategories = allCategories else { return }
                self.allCategories = []
                var dict : [String:Any] = [:]
                dict["id"] = ""
                dict["nameEn"] = " All "
                dict["nameAr"] = " الجميع "
                let objCate = ItemSubCategory(dict: dict)
                self.allCategories.append(objCate)
                self.allCategories.append(contentsOf: allCategories)
                
                if self.allCategories.count > 0 {
                    self.selectedCategory = self.allCategories[0]
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        if self.user?.id == AppUser.shared.getDefaultUser()?.id {
                            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["myItem":self.allCategories[0].id])
                        } else {
                            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_Other"), object: nil, userInfo: ["myItem":self.allCategories[0].id])
                        }
                    })
                }
                self.collectionCategory.reloadData()
            }
        }
    }

    //MARK: - DataSource UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionCategory {
            return allCategories.count
        }
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionCategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCCell.reuseIdentifier, for: indexPath) as! CategoryCCell
            cell.lblTitle.text = allCategories[indexPath.row].nameEn
            cell.viewMain.setRadius(radius: 5)
            if allCategories[indexPath.row].id == selectedCategory?.id {
                cell.viewMain.backgroundColor = .gradientSecondColor
                cell.lblTitle.textColor = .white
            } else {
                cell.viewMain.backgroundColor = .white
                cell.lblTitle.textColor = UIColor.hex("#807F7F")
            }
            cell.viewMain.layer.borderColor = UIColor.gradientSecondColor.cgColor
            cell.viewMain.layer.borderWidth = 1
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCell.reuseIdentifier, for: indexPath) as! ExploreCell
        cell.post = items[indexPath.row]
        cell.hiddenImg.isHidden = true
        cell.purchaseImg.isHidden = true
        return cell
    }
    
    //MARK: - Delegate UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionCategory {
            selectedCategory = self.allCategories[indexPath.row]
            self.collectionCategory.reloadData()
            if self.user?.id == AppUser.shared.getDefaultUser()?.id {
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["myItem":self.allCategories[indexPath.row].id])
            } else {
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_Other"), object: nil, userInfo: ["myItem":self.allCategories[indexPath.row].id])
            }

        } else {
            let item = items[indexPath.row]
            delegate?.didSelectProduct(withId: item.id, ofType: item.type, post: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionCategory {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        } else {
            return UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Str = allCategories[indexPath.row].nameEn
        let Font =  UIFont.systemFont(ofSize: 20)
        let SizeOfString = Str.SizeOf_String(font: Font).width
        return CGSize(width: (SizeOfString + 15), height: 50)
    }

    
}

