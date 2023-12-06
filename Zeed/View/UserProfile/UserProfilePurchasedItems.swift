//
//  UserProfilePurchasedItems.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit
import SquareFlowLayout

protocol UserProfilePurchasedItemsDelegate: AnyObject {
    func didSelectPurchase(withId id: String, ofType type: PostType, post:PostItem?)
}

class UserProfilePurchasedItems: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    weak var delegate: UserProfilePurchasedItemsDelegate?

    var user: User?
    var selectedCategory: ItemSubCategory?
    var allCategories: [ItemSubCategory] = []
    let collectionCategory :UICollectionView = {
        //        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: 90, height: 50)
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60), collectionViewLayout: UICollectionViewFlowLayout.init())
        collection.backgroundColor = .appBackgroundColor
        //        layout.scrollDirection = .horizontal
        return collection
    }()
    
    var items = [PurchasedPostItem]() {
        didSet {
            if items.count == 0 {
                noPostsAvailableLabel.alpha = 1
            } else {
                noPostsAvailableLabel.alpha = 0
            }
            collectionView.reloadData()
        }
    }
    
    //MARK: - UI Elements
    private let noPostsAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? No_data_available_ar : No_data_available_en
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    
    //MARK: - Lifecycle
    init() {
        let layout = SquareFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        title = appDele!.isForArabic ? Purchase_ar : Purchase_en
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: ExploreCell.reuseIdentifier)
        self.collectionView.contentInset = UIEdgeInsets.init(top: 70, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "Profile_Purchase_Item", str_nib_name: self.nibName ?? "")

        collectionCategory.delegate = self
        collectionCategory.dataSource = self
        collectionCategory.registerNib(nibName: "CategoryCCell", reUse: "CategoryCCell")
        
        
        configureUI()
        
        view.addSubview(noPostsAvailableLabel)
        noPostsAvailableLabel.centerX(inView: collectionView)
        noPostsAvailableLabel.centerY(inView: collectionView)
        noPostsAvailableLabel.alpha = 0
        
        setupToHideKeyboardOnTapOnView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("CallCategoryService"), object: nil)

    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.fetchCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCategories()
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .backgroundWhiteColor
        self.view.addSubview(collectionCategory)
        collectionView.isScrollEnabled = false
    }
    
    //MARK: - API
    func fetchCategories() {
        Service.shared.getAllSubCategories(isPurchaseItem: true, userId: user?.id ?? "") { (allCategories, status, message) in
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
                    if self.user?.id == AppUser.shared.getDefaultUser()?.id {
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["purchaseId":self.allCategories[0].id])
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_Other"), object: nil, userInfo: ["purchaseId":self.allCategories[0].id])
                    }
                }
                self.collectionCategory.reloadData()
            } else {
                guard let message = message else { return }
                //                self.showAlert(withMsg: "Error fetching categories: \(message)")
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
        cell.galleryImageView.image = UIImage(named: "logo")
        cell.galleryImageView.loadImage(from: items[indexPath.row].medias.first?.url ?? "")
        cell.galleryImageView.isUserInteractionEnabled = true
        cell.galleryImageView.tag = indexPath.item
            

        cell.purchaseImg.isHidden = false
        
        cell.hiddenImg.isHidden = false
        
        if loggedInUser?.id == user?.id {
            cell.hiddenImg.image = UIImage(named: items[indexPath.row].purchaseStatus.hidden == "1" ? "hidden" : "")
        } else {
            cell.hiddenImg.isHidden = true
        }
        
        cell.galleryImageView.backgroundColor = .random
        
        if items[indexPath.row].postBaseType == .normalSelling {
            cell.purchaseImg.isHidden = true
        } else {
            cell.purchaseImg.isHidden = false
        }
        
        
        let singleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(UserProfilePurchasedItems.handleSingleTap(sender:)))
        singleTap.numberOfTapsRequired = 1
        cell.galleryImageView.addGestureRecognizer(singleTap)
        
        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserProfilePurchasedItems.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        cell.galleryImageView.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(UserProfilePurchasedItems.longPress(longPressGestureRecognizer:)))
        cell.galleryImageView.addGestureRecognizer(longPressRecognizer)
        
        
        return cell
    }
    
    @objc func handleSingleTap(sender: AnyObject?) {
        let item = items[sender?.view.tag ?? 0]
        self.delegate?.didSelectPurchase(withId: item.id, ofType: item.type, post: nil)
        print("Single Tap!")
    }
    @objc func handleDoubleTap() {
        
        print("Double Tap!")
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if AppUser.shared.getDefaultUser()?.id == self.user?.id {
            let item = items[longPressGestureRecognizer.view?.tag ?? 0]
            
            print("DEBUG:- IRTEM TYPE: \(item.type)")
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: item.purchaseStatus.hidden == "0" ? ( appDele!.isForArabic ? Hide_purchase_ar : Hide_purchase_en) : ( appDele!.isForArabic ? UnHide_purchase_ar : UnHide_purchase_en), style: .default, handler: { alert in
                Service.shared.makeSinglePurchaseHidden(setHidden: item.purchaseStatus.hidden == "1" ? false : true, purchaseId: item.purchaseStatus.purchaseId) { status in
                    if status {
                        loggedInUser!.isPublic.toggle()
                        defaults.set(nil, forKey: "USER")
                        do {
                            self.items[longPressGestureRecognizer.view?.tag ?? 0].purchaseStatus.hidden = item.purchaseStatus.hidden == "1" ? "0" : "1"
                            
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(loggedInUser!)
                            defaults.set(data, forKey: "USER")
                            self.collectionView.reloadData()
                        }catch{
                            print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
                        }
                        self.collectionView.reloadData()
                        self.showAlert(withMsg: appDele!.isForArabic ? Post_details_updated_successfully_ar : Post_details_updated_successfully_en)
                    } else {
                        
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .cancel, handler: { alert in
                
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - Delegate UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionCategory {
            selectedCategory = self.allCategories[indexPath.row]
            self.collectionCategory.reloadData()
            if self.user?.id == AppUser.shared.getDefaultUser()?.id {
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["purchaseId":self.allCategories[indexPath.row].id])
            } else {
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_Other"), object: nil, userInfo: ["purchaseId":self.allCategories[indexPath.row].id])
            }

            
            return
        }
        let item = items[indexPath.row]
        print("DEBUG:- IRTEM TYPE: \(item.type)")
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: item.purchaseStatus.hidden == "0" ? ( appDele!.isForArabic ? Hide_purchase_ar : Hide_purchase_en) : ( appDele!.isForArabic ? UnHide_purchase_ar : UnHide_purchase_en), style: .default, handler: { alert in
            Service.shared.makeSinglePurchaseHidden(setHidden: item.purchaseStatus.hidden == "1" ? false : true, purchaseId: item.purchaseStatus.purchaseId) { status in
                if status {
                    loggedInUser!.isPublic.toggle()
                    defaults.set(nil, forKey: "USER")
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(loggedInUser!)
                        defaults.set(data, forKey: "USER")
                        collectionView.reloadData()
                    }catch{
                        print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
                    }
                    collectionView.reloadData()
                    self.showAlert(withMsg: appDele!.isForArabic ? Post_details_updated_successfully_ar : Post_details_updated_successfully_en)
                } else {
                    
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? View_ar  : View_en, style: .default, handler: { alert in
            self.delegate?.didSelectPurchase(withId: item.id, ofType: item.type, post: nil)
        }))
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .cancel, handler: { alert in
            
        }))
        present(alert, animated: true, completion: nil)
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

extension String {
    func SizeOf_String( font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size;
    }
}
