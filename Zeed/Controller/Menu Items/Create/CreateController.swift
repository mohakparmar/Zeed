//
//  CreateController.swift
//  Zeed
//
//  Created by Shrey Gupta on 07/04/21.
//

import UIKit
import DatePickerDialog
import SDWebImage
import JGProgressHUD

enum CreateControllerFixedSections: Int, CaseIterable {
    case uploadImages
    case selectCategory
    case selectSubCategory
    case title
    case titleAr
//    case saleType
    case itemDetails
    case itemDetailsAr
    case price
    case quantityAvailable
    case actionButtons
    
    var description: String {
        switch self {
        case .uploadImages:
            return appDele!.isForArabic ? Upload_Images_ar : Upload_Images_en
        case .selectCategory:
            return appDele!.isForArabic ? Select_Category_ar : Select_Category_en
        case .selectSubCategory:
            return appDele!.isForArabic ? Select_Sub_Category_ar : Select_Sub_Category_en
        case .title:
            return appDele!.isForArabic ? Title1_ar : Title_en
        case .titleAr:
            return appDele!.isForArabic ? Title_AR_ar : Title_AR_en
//        case .saleType:
//            return appDele!.isForArabic ? Sale_Type_ar : Sale_Type_en
        case .itemDetails:
            return appDele!.isForArabic ? Details_ar : Details_en
        case .itemDetailsAr:
            return appDele!.isForArabic ? "التفاصيل بالعربية" : "Details Arabic"
        case .price:
            return appDele!.isForArabic ? Price_ar : Price_en
        case .quantityAvailable:
            return appDele!.isForArabic ? Quantity_Available_ar : Quantity_Available_en
        case .actionButtons:
            return ""
        }
    }
    
    var height: CGFloat {
        switch self {
        case .uploadImages:
            return 80
        case .selectCategory:
            return 50
        case .selectSubCategory:
            return 50
        case .title:
            return 50
        case .titleAr:
            return 50
//        case .saleType:
//            return 60
        case .itemDetails:
            return 100
        case .itemDetailsAr:
            return 100
        case .price:
            return 50
        case .quantityAvailable:
            return 50
        case .actionButtons:
            return 60
        }
    }
}

enum CreateControllerAuctionSections: Int, CaseIterable {
    case uploadImages
    case selectCategory
    case selectSubCategory
    
    case title
    case titleAr
//    case saleType
    case startDate_duration
    case itemDetails
    case itemDetailsAr
    case initialPrice
    
    case actionButtons
    
    var description: String {
        switch self {
        case .uploadImages:
            return appDele!.isForArabic ? Upload_Images_ar : Upload_Images_en
        case .selectCategory:
            return appDele!.isForArabic ? Select_Category_ar : Select_Category_en
        case .selectSubCategory:
            return appDele!.isForArabic ? Select_Sub_Category_ar : Select_Sub_Category_en
        case .title:
            return appDele!.isForArabic ? Title1_ar : Title_en
        case .titleAr:
            return appDele!.isForArabic ? Title_AR_ar : Title_AR_en
//        case .saleType:
//            return appDele!.isForArabic ? Sale_Type_ar : Sale_Type_en
        case .itemDetails:
            return appDele!.isForArabic ? Details_ar : Details_en
        case .itemDetailsAr:
            return appDele!.isForArabic ? Details_Arabic_ar : Details_Arabic_en
        case .actionButtons:
            return ""
        case .startDate_duration:
            return ""
        case .initialPrice:
            return appDele!.isForArabic ? Start_price_ar : Start_price_en
        }
    }
    
    
    
    var height: CGFloat {
        switch self {
        case .uploadImages:
            return 80
        case .selectCategory:
            return 50
        case .selectSubCategory:
            return 50
        case .title:
            return 50
        case .titleAr:
            return 50
//        case .saleType:
//            return 60
        case .itemDetails:
            return 100
        case .itemDetailsAr:
            return 100
        case .actionButtons:
            return 60
        case .startDate_duration:
            return 60
        case .initialPrice:
            return 50
        }
    }
}

enum CreateControllerLiveAuctionSections: Int, CaseIterable {
    case uploadImages
    case selectCategory
    case selectSubCategory
    case title
    case titleAr
//    case saleType
    case startDate
    case itemDetails
    case itemDetailsAr
    case initialPrice
    
    case actionButtons
    
    var description: String {
        switch self {
        case .uploadImages:
            return appDele!.isForArabic ? Upload_Images_ar : Upload_Images_en
        case .selectCategory:
            return appDele!.isForArabic ? Select_Category_ar : Select_Category_en
        case .selectSubCategory:
            return appDele!.isForArabic ? Select_Sub_Category_ar : Select_Sub_Category_en
        case .title:
            return appDele!.isForArabic ? Title1_ar : Title_en
        case .titleAr:
            return appDele!.isForArabic ? Title_AR_ar : Title_AR_en
//        case .saleType:
//            return appDele!.isForArabic ? Sale_Type_ar : Sale_Type_en
        case .itemDetails:
            return appDele!.isForArabic ? Details_ar : Details_en
        case .itemDetailsAr:
            return appDele!.isForArabic ? "التفاصيل بالعربية" : "Details Arabic"
        case .actionButtons:
            return ""
        case .startDate:
            return ""
        case .initialPrice:
            return appDele!.isForArabic ? Start_price_ar : Start_price_en
        }
    }
    
    var height: CGFloat {
        switch self {
        case .uploadImages:
            return 80
        case .selectCategory:
            return 50
        case .selectSubCategory:
            return 50
        case .title:
            return 50
        case .titleAr:
            return 50
//        case .saleType:
//            return 60
        case .itemDetails:
            return 100
        case .itemDetailsAr:
            return 100
        case .actionButtons:
            return 60
        case .startDate:
            return 60
        case .initialPrice:
            return 50
        }
    }
}


class CreateController: UITableViewController {
    //MARK: - Properties
    var postBaseType: PostBaseType = .normalSelling {
        didSet {
            tableView.reloadData()
        }
    }
    
    var postItem : PostItem?
    
    var categoryPicker = CategoryPicker()
    var durationPicker = AuctionDurationPicker()
    var blackView = UIView()
    
    var createItemCategories = [CreateItemCategory]()
    
    private let imagePicker = UIImagePickerController()
    
    //MARK: - Item Details
    var itemImages = [UIImage]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var itemTitle: String?
    var itemTitleAr: String?
    
    var itemDescription: String?
    var itemDescriptionAr: String?
    
    var itemCategory: ItemCategory? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var itemSubCategory: ItemSubCategory? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    var itemPrice: Double?
    var itemQuantity: Int?
    var itemVariants = [CreateItemVariant]()
    var itemStartDate: Date? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var arrVariant : [VariantObject] = []
    
    var duration: AuctionDuration? {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        button.tintColor = .appPrimaryColor
        
        return button
    }()
    
    
    
    func setPostData() {
        itemTitle = postItem?.title
        itemTitleAr = postItem?.title_ar
        itemDescription = postItem?.about
        itemDescriptionAr = postItem?.location
        itemCategory = postItem?.category
        itemSubCategory = postItem?.subCategory
        itemPrice = postItem?.price
        itemQuantity = postItem?.quantity
        postBaseType = postItem!.postBaseType
        if let arr = self.postItem?.medias {
            for itm in arr {
                SDWebImageManager.shared().loadImage(
                    with: URL(string: itm.url),
                    options: .highPriority,
                    progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                        print(isFinished)
                        if let im = image {
                            im.accessibilityIdentifier = itm.id
                            self.itemImages.append(im)
                        }
                    }
            }
        }

        self.arrVariant = []
        for item in self.postItem?.variants ?? [] {
            let obj = VariantObject()
            obj.strId = item.id
            if item.attributes.count > 1 {
                obj.strV2Eng = item.attributes[1].type.name
                obj.strV2Ar = item.attributes[1].type.name_ar
            }
            if item.attributes.count > 0 {
                obj.strV1Eng = item.attributes[0].type.name
                obj.strV1Ar = item.attributes[0].type.name_ar
            }
            obj.strPrice = "\(item.price)"
            obj.strQuantity = "\(item.quantity)"
            self.arrVariant.append(obj)
        }
        
        self.tableView.reloadData()
        
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: appDele!.isForArabic ? Post_a_Product_ar : Post_a_Product_en, preferredLargeTitle: false)
        
        Utility.openScreenView(str_screen_name: "Crete_Post", str_nib_name: self.nibName ?? "")

        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        tableView.register(CreatePhotos.self, forCellReuseIdentifier: CreatePhotos.reuseIdentifier)
        tableView.register(CreateSelectCategoryCell.self, forCellReuseIdentifier: CreateSelectCategoryCell.reuseIdentifier)
        tableView.register(CreateTitleCell.self, forCellReuseIdentifier: CreateTitleCell.reuseIdentifier)
        tableView.register(CreateSaleTypeCell.self, forCellReuseIdentifier: CreateSaleTypeCell.reuseIdentifier)
        tableView.register(CreateDescriptionCell.self, forCellReuseIdentifier: CreateDescriptionCell.reuseIdentifier)
        tableView.register(CreatePriceCell.self, forCellReuseIdentifier: CreatePriceCell.reuseIdentifier)
        tableView.register(CreateQuantityCell.self, forCellReuseIdentifier: CreateQuantityCell.reuseIdentifier)
        tableView.register(CreateActionButtonCell.self, forCellReuseIdentifier: CreateActionButtonCell.reuseIdentifier)
        tableView.register(CreateStartDateCell.self, forCellReuseIdentifier: CreateStartDateCell.reuseIdentifier)
        tableView.register(CreateStartDateDurationCell.self, forCellReuseIdentifier: CreateStartDateDurationCell.reuseIdentifier)
        tableView.register(CreateInitialPriceCell.self, forCellReuseIdentifier: CreateInitialPriceCell.reuseIdentifier)
        tableView.register(UINib(nibName: "SubCategoryTCell", bundle: nil), forCellReuseIdentifier: "SubCategoryTCell")
        
        
        categoryPicker.delegate = self
        durationPicker.delegate = self
        
        configureUI()
        fetchCreateItemCategories()
        setupToHideKeyboardOnTapOnView()
        
        if self.postItem?.id.checkEmpty() == false {
            setPostData()
        }
    }
    
    func fetchCreateItemCategories() {
        Service.shared.getAllCategories { (allCategories, status, message) in
            if status {
                guard let allCategories = allCategories else { return }
                self.categoryPicker.allCategories = allCategories
                self.tableView.reloadData()
            } else {
                
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleDismiss() {
        self.navigationController?.popViewController(animated: true)
        //        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 0
            self.categoryPicker.frame.origin.y = UIScreen.main.bounds.height
            self.durationPicker.frame.origin.y = UIScreen.main.bounds.height
        } completion: { (_) in
            self.blackView.removeFromSuperview()
            self.categoryPicker.removeFromSuperview()
            self.durationPicker.removeFromSuperview()
        }
    }
    
    //MARK: - Helper Funtions
    func configureUI() {
        tableView.backgroundColor = .appBackgroundColor
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
    }
    
    func bringBlackView() {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        blackView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        blackView.gestureRecognizers = [tap]
        blackView.isUserInteractionEnabled = true
        
        UIApplication.shared.keyWindow?.addSubview(blackView)
        blackView.fillSuperview()
    }
    
    func bringCategoryPicker() {
        categoryPicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.5)
        
        bringBlackView()
        
        UIApplication.shared.keyWindow?.addSubview(categoryPicker)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 1
            self.categoryPicker.frame.origin.y = UIScreen.main.bounds.height - (UIScreen.main.bounds.height/2.5)
        }
    }
    
    func bringDurationPicker() {
        durationPicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.5)
        
        bringBlackView()
        
        UIApplication.shared.keyWindow?.addSubview(durationPicker)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 1
            self.durationPicker.frame.origin.y = UIScreen.main.bounds.height - (UIScreen.main.bounds.height/2.5)
        }
    }
    
    //MARK: - DataSource & Delegate UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch postBaseType {
        case .normalSelling:
            return CreateControllerFixedSections.allCases.count
        case .normalBidding:
            return CreateControllerAuctionSections.allCases.count
        case .liveBidding:
            return CreateControllerLiveAuctionSections.allCases.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTypeText = ""
        
        switch postBaseType {
        case .normalSelling:
            let sectionType = CreateControllerFixedSections(rawValue: section)!
            sectionTypeText = sectionType.description
        case .normalBidding:
            let sectionType = CreateControllerAuctionSections(rawValue: section)!
            sectionTypeText = sectionType.description
        case .liveBidding:
            let sectionType = CreateControllerLiveAuctionSections(rawValue: section)!
            sectionTypeText = sectionType.description
        }
        
        
        let customView = UIView()
        customView.backgroundColor = .appBackgroundColor
        customView.alpha = 0.7
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = sectionTypeText
        
        customView.addSubview(label)
        label.anchor(left: customView.leftAnchor, right: customView.rightAnchor, paddingLeft: 10, paddingRight: 10)
        label.centerY(inView: customView)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: customView)
        }
        
        return customView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var isWithoutHeader = false
        
        switch postBaseType {
        case .normalSelling:
            let sectionType = CreateControllerFixedSections(rawValue: section)!
            if sectionType == .actionButtons {
                isWithoutHeader = true
            } else {
                isWithoutHeader = false
            }
        case .normalBidding:
            let sectionType = CreateControllerAuctionSections(rawValue: section)!
            if sectionType == .actionButtons || sectionType == .startDate_duration {
                isWithoutHeader = true
            } else {
                isWithoutHeader = false
            }
        case .liveBidding:
            let sectionType = CreateControllerLiveAuctionSections(rawValue: section)!
            if sectionType == .actionButtons || sectionType == .startDate {
                isWithoutHeader = true
            } else {
                isWithoutHeader = false
            }
        }
        
        if isWithoutHeader {
            return 0
        } else {
            return 28
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch postBaseType {
        case .normalSelling:
            let sectionType = CreateControllerFixedSections(rawValue: indexPath.section)!
            return sectionType.height
        case .normalBidding:
            let sectionType = CreateControllerAuctionSections(rawValue: indexPath.section)!
            if sectionType == .startDate_duration &&  (self.postItem?.id.count ?? 0 > 0) {
                return 0
            }
            return sectionType.height
        case .liveBidding:
            let sectionType = CreateControllerLiveAuctionSections(rawValue: indexPath.section)!
            if sectionType == .startDate &&  (self.postItem?.id.count ?? 0 > 0) {
                return 0
            }
            return sectionType.height
        }
        
    }
    
    
    var hud = JGProgressHUD(style: .dark)
    var arrSubCategory : [ItemSubCategory] = []
    func openSubcategoryAlert() {
        guard let category = itemCategory else {
            self.showAlert(withMsg: "Please select a Category!")
            self.view.isUserInteractionEnabled = true
            return
        }
        
        hud.show(in: self.view, animated: true)
        Service.shared.getSubCategoryList(cateId: category.id) { status, arr, message in
            self.hud.dismiss(animated: true)
            if arr.count == 0 {
                self.showAlert(withMsg: "Please add subcategory now. You have not added any yet.")
            } else {
                self.arrSubCategory = arr
                self.openSelection()
            }
        }
    }
    
    func openSelection() {
        let arr = self.arrSubCategory.map({ $0.nameEn })
        let alert = UIAlertController(title: "Select Sub Category", message: "", preferredStyle: .actionSheet)
        alert.addPickerView(values: arr) { vc, picker, index, values in
            self.itemSubCategory = self.arrSubCategory[index.row]
        }
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
        }
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openAddSubCategory() {
        guard let category = itemCategory else {
            self.showAlert(withMsg: "Please select a Category!")
            self.view.isUserInteractionEnabled = true
            return
        }
        let obj = SubcategoryController()
        obj.cateogry = category
        obj.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch postBaseType {
        case .normalSelling:
            let sectionType = CreateControllerFixedSections(rawValue: indexPath.section)!
            
            switch sectionType {
            case .uploadImages:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreatePhotos.reuseIdentifier) as! CreatePhotos
                cell.delegate = self
                cell.itemImages = itemImages
                cell.selectionStyle = .none
                return cell
                
            case .selectCategory:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateSelectCategoryCell.reuseIdentifier) as! CreateSelectCategoryCell
                cell.itemCategory = itemCategory
                cell.selectionStyle = .none
                return cell
            case .selectSubCategory:
                let cell = tableView.dequeueReusableCell(withIdentifier: SubCategoryTCell.reuseIdentifier) as! SubCategoryTCell
                cell.itemSub = itemSubCategory
                cell.selectionStyle = .none
                cell.btnPlusClick = {
                    self.openAddSubCategory()
                }
                
                if appDele!.isForArabic == true {
                    ConvertArabicViews.init().convertSingleView(toAr: cell.contentView)
                    cell.lblSubCategory.textAlignment = .right
                }
                return cell
            case .title:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateTitleCell.reuseIdentifier) as! CreateTitleCell
                cell.delegate = self
                cell.selectionStyle = .none
                cell.title = self.itemTitle
                cell.isEnglish = true
                return cell
                
//            case .saleType:
//                let cell = tableView.dequeueReusableCell(withIdentifier: CreateSaleTypeCell.reuseIdentifier) as! CreateSaleTypeCell
//                cell.delegate = self
//                cell.selectedSaleType = postBaseType
//                cell.isEditPossible = (self.postItem?.id.count ?? 0 > 0) ? false : true
//                cell.selectionStyle = .none
//                return cell
                
            case .itemDetails:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateDescriptionCell.reuseIdentifier) as! CreateDescriptionCell
                cell.delegate = self
                cell.isEng = true
                cell.desc = self.itemDescription
                cell.selectionStyle = .none
                return cell
                
            case .itemDetailsAr:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateDescriptionCell.reuseIdentifier) as! CreateDescriptionCell
                cell.delegate = self
                cell.isEng = false
                cell.desc = self.itemDescriptionAr
                cell.selectionStyle = .none
                return cell
                
            case .price:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreatePriceCell.reuseIdentifier) as! CreatePriceCell
                cell.delegate = self
                cell.selectionStyle = .none
                if (self.postItem?.id.count ?? 0 > 0) {
                    cell.price = "\(itemPrice ?? 0)"
                }
                return cell
                
            case .quantityAvailable:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateQuantityCell.reuseIdentifier) as! CreateQuantityCell
                cell.delegate = self
                cell.selectionStyle = .none
                if (self.postItem?.id.count ?? 0 > 0) {
                    cell.price = "\(itemQuantity ?? 0)"
                }
                return cell
                
            case .actionButtons:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateActionButtonCell.reuseIdentifier) as! CreateActionButtonCell
                cell.delegate = self
                cell.isVariantEnabled = true
                cell.selectionStyle = .none
                return cell
            case .titleAr:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateTitleCell.reuseIdentifier) as! CreateTitleCell
                cell.delegate = self
                cell.selectionStyle = .none
                cell.title = itemTitleAr
                cell.isEnglish = false
                return cell
            }
        case .normalBidding:
            let sectionType = CreateControllerAuctionSections(rawValue: indexPath.section)!
            
            switch sectionType {
            case .uploadImages:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreatePhotos.reuseIdentifier) as! CreatePhotos
                cell.delegate = self
                cell.itemImages = itemImages
                cell.selectionStyle = .none
                return cell
                
            case .selectCategory:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateSelectCategoryCell.reuseIdentifier) as! CreateSelectCategoryCell
                cell.itemCategory = itemCategory
                cell.selectionStyle = .none
                return cell
            case .selectSubCategory:
                let cell = tableView.dequeueReusableCell(withIdentifier: SubCategoryTCell.reuseIdentifier) as! SubCategoryTCell
                cell.itemSub = itemSubCategory
                cell.selectionStyle = .none
                cell.btnPlusClick = {
                    self.openAddSubCategory()
                }
                if appDele!.isForArabic == true {
                    ConvertArabicViews.init().convertSingleView(toAr: cell.contentView)
                    cell.lblSubCategory.textAlignment = .right
                }
                return cell
                
                
            case .title:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateTitleCell.reuseIdentifier) as! CreateTitleCell
                cell.delegate = self
                cell.isEnglish = true
                cell.selectionStyle = .none
                cell.title = itemTitle
                return cell
                
//            case .saleType:
//                let cell = tableView.dequeueReusableCell(withIdentifier: CreateSaleTypeCell.reuseIdentifier) as! CreateSaleTypeCell
//                cell.delegate = self
//                cell.selectedSaleType = postBaseType
//                cell.isEditPossible = (self.postItem?.id.count ?? 0 > 0) ? false : true
//                cell.selectionStyle = .none
//                return cell
                
            case .itemDetails:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateDescriptionCell.reuseIdentifier) as! CreateDescriptionCell
                cell.delegate = self
                cell.isEng = true
                cell.desc = self.itemDescription
                cell.selectionStyle = .none
                return cell
                
            case .itemDetailsAr:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateDescriptionCell.reuseIdentifier) as! CreateDescriptionCell
                cell.delegate = self
                cell.isEng = false
                cell.desc = self.itemDescriptionAr
                cell.selectionStyle = .none
                return cell
                
            case .startDate_duration:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateStartDateDurationCell.reuseIdentifier) as! CreateStartDateDurationCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.date = itemStartDate
                cell.duration = duration
                return cell
                
            case .initialPrice:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateInitialPriceCell.reuseIdentifier) as! CreateInitialPriceCell
                cell.delegate = self
                cell.selectionStyle = .none
                if (self.postItem?.id.count ?? 0 > 0) {
                    cell.price = "\(itemPrice ?? 0)"
                }
                
                return cell
                
            case .actionButtons:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateActionButtonCell.reuseIdentifier) as! CreateActionButtonCell
                cell.delegate = self
                cell.isVariantEnabled = false
                cell.selectionStyle = .none
                return cell
            case .titleAr:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateTitleCell.reuseIdentifier) as! CreateTitleCell
                cell.delegate = self
                cell.isEnglish = false
                cell.title = itemTitleAr
                cell.selectionStyle = .none
                return cell
                
            }
        case .liveBidding:
            let sectionType = CreateControllerLiveAuctionSections(rawValue: indexPath.section)!
            
            switch sectionType {
            case .uploadImages:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreatePhotos.reuseIdentifier) as! CreatePhotos
                cell.delegate = self
                cell.itemImages = itemImages
                cell.selectionStyle = .none
                return cell
                
            case .selectCategory:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateSelectCategoryCell.reuseIdentifier) as! CreateSelectCategoryCell
                cell.itemCategory = itemCategory
                cell.selectionStyle = .none
                return cell
            case .selectSubCategory:
                let cell = tableView.dequeueReusableCell(withIdentifier: SubCategoryTCell.reuseIdentifier) as! SubCategoryTCell
                cell.itemSub = itemSubCategory
                cell.selectionStyle = .none
                cell.btnPlusClick = {
                    self.openAddSubCategory()
                }
                if appDele!.isForArabic == true {
                    ConvertArabicViews.init().convertSingleView(toAr: cell.contentView)
                    cell.lblSubCategory.textAlignment = .right
                }
                return cell
                
            case .title:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateTitleCell.reuseIdentifier) as! CreateTitleCell
                cell.delegate = self
                cell.selectionStyle = .none
                cell.isEnglish = true
                cell.title = itemTitle
                return cell
                
//            case .saleType:
//                let cell = tableView.dequeueReusableCell(withIdentifier: CreateSaleTypeCell.reuseIdentifier) as! CreateSaleTypeCell
//                cell.delegate = self
//                cell.selectedSaleType = postBaseType
//                cell.isEditPossible = (self.postItem?.id.count ?? 0 > 0) ? false : true
//                cell.selectionStyle = .none
//                return cell
                
            case .itemDetails:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateDescriptionCell.reuseIdentifier) as! CreateDescriptionCell
                cell.delegate = self
                cell.isEng = true
                cell.selectionStyle = .none
                cell.desc = self.itemDescription
                return cell
                
            case .itemDetailsAr:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateDescriptionCell.reuseIdentifier) as! CreateDescriptionCell
                cell.delegate = self
                cell.isEng = false
                cell.selectionStyle = .none
                cell.desc = self.itemDescriptionAr
                return cell
                
            case .startDate:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateStartDateCell.reuseIdentifier) as! CreateStartDateCell
                cell.selectionStyle = .none
                cell.date = itemStartDate
                return cell
                
            case .initialPrice:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateInitialPriceCell.reuseIdentifier) as! CreateInitialPriceCell
                cell.delegate = self
                cell.selectionStyle = .none
                if (self.postItem?.id.count ?? 0 > 0) {
                    cell.price = "\(itemPrice ?? 0)"
                }
                return cell
                
            case .actionButtons:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateActionButtonCell.reuseIdentifier) as! CreateActionButtonCell
                cell.delegate = self
                cell.isVariantEnabled = false
                cell.selectionStyle = .none
                return cell
            case .titleAr:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateTitleCell.reuseIdentifier) as! CreateTitleCell
                cell.delegate = self
                cell.selectionStyle = .none
                cell.isEnglish = false
                cell.title = itemTitleAr
                return cell
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch postBaseType {
        case .normalSelling:
            let sectionType = CreateControllerFixedSections(rawValue: indexPath.section)!
            
            switch sectionType {
            case .selectCategory:
                bringCategoryPicker()
            case .selectSubCategory:
                openSubcategoryAlert()
            default:
                break
            }
        case .normalBidding:
            let sectionType = CreateControllerAuctionSections(rawValue: indexPath.section)!
            
            switch sectionType {
            case .selectCategory:
                bringCategoryPicker()
            case .selectSubCategory:
                openSubcategoryAlert()
            default:
                break
            }
        case .liveBidding:
            let sectionType = CreateControllerLiveAuctionSections(rawValue: indexPath.section)!
            
            switch sectionType {
            case .selectCategory:
                bringCategoryPicker()
            case .selectSubCategory:
                openSubcategoryAlert()
            case .startDate:
                DatePickerDialog().show(appDele!.isForArabic ? Auction_Start_Date_ar : Auction_Start_Date_en, doneButtonTitle: appDele!.isForArabic ? Done_ar : Done_en, cancelButtonTitle: appDele!.isForArabic ? Cancel_ar : Cancel_en, datePickerMode: .dateAndTime) { date in
                    if let dt = date {
                        self.itemStartDate = dt
                    }
                }
            default:
                break
            }
        }
    }
}

//MARK: - Delegate CategoryPickerDelegate
extension CreateController: CategoryPickerDelegate {
    func categoryPicker(_ categoryPicker: CategoryPicker, didSelectCategory category: ItemCategory, at indexPath: IndexPath) {
        self.itemCategory = category
        self.itemSubCategory = ItemSubCategory(dict: [:])
        self.dismissPicker()
    }
}

//MARK: - Delegate UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CreateController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        if (self.postItem?.id.count ?? 0 > 0) {
            Service.shared.uploadSingleImage(image: selectedImage) { isTrue, objMedia, str in
                DispatchQueue.main.async {
                    if isTrue == true {
                        if objMedia!.count > 0 {
                            selectedImage.accessibilityIdentifier = objMedia![0].id
                            self.itemImages.append(selectedImage)
                            self.postItem?.medias.append(objMedia![0])
                        }
                    }
                }
            }
        } else {
            itemImages.append(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Delegate CreatePhotosDelegate
extension CreateController: CreatePhotosDelegate {
    func didAddImage() {
        let alert = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Camera_ar : Camera_en, style: .default, handler: {_ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Gallery_ar : Gallery_en, style: .default, handler: {_ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .cancel, handler: {_ in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func didDeleteImage(image: UIImage) {
        self.postItem?.medias.removeAll(where: { (img) -> Bool in
            return img.id == image.accessibilityIdentifier
        })
        
        self.itemImages.removeAll(where: { (img) -> Bool in
            return img == image
        })
    }
}

//MARK: - Delegate CreateStartDateDurationCellDelegate
extension CreateController: CreateStartDateDurationCellDelegate {
    func handleDateTapped() {
        DatePickerDialog().show(appDele!.isForArabic ? Auction_Start_Date_ar : Auction_Start_Date_en, doneButtonTitle: appDele!.isForArabic ? Done_ar : Done_en, cancelButtonTitle: appDele!.isForArabic ? Cancel_ar : Cancel_en, datePickerMode: .date) { date in
            if let dt = date {
                self.itemStartDate = dt
            }
        }
    }
    
    func handleDurationTapped() {
        bringDurationPicker()
    }
}

//MARK: - Delegate CreateTitleCellDelegate
extension CreateController: CreateTitleCellDelegate {
    func didChangeTitle(title: String, isEng: Bool) {
        if isEng == true {
            self.itemTitle = title
        } else {
            self.itemTitleAr = title
        }
    }
    
}

extension CreateController: CreateSaleTypeCellDelegate {
    func didSelectSaleType(type: PostBaseType) {
        if self.postItem?.id.count ?? 0 > 0 {
        } else {
            self.postBaseType = type
        }
    }
}

extension CreateController: CreateDescriptionDelegate {
    func didChangeDescription(with text: String, isEnglish: Bool) {
        if isEnglish == true {
            self.itemDescription = text
        } else {
            self.itemDescriptionAr = text
        }
    }
}

extension CreateController: CreatePriceCellDelegate {
    func didChangePrice(with price: Double) {
        self.itemPrice = price
    }
}

extension CreateController: CreateQuantityCellDelegate {
    func didChangeQuantity(with quantity: Int) {
        self.itemQuantity = quantity
    }
}

extension CreateController: CreateInitialPriceCellDelegate {
    func didChangeInitialPrice(with price: Double) {
        self.itemPrice = price
    }
}

//MARK: - Delegate CreateActionButtonCellDelegate
extension CreateController: CreateActionButtonCellDelegate {
    func didTapAddVarient() {
        if (self.postItem?.id.count ?? 0 > 0) {
            let obj = AddVariantVC()
            obj.delegate = self
            obj.postItem = self.postItem
            obj.arrVariant = self.arrVariant
            navigationController?.pushViewController(obj, animated: true)

        } else {
            let obj = AddVariantVC()
            obj.delegate = self
            obj.arrVariant = self.arrVariant
            navigationController?.pushViewController(obj, animated: true)
        }
        
        //        let controller = AddVariantController(fromController: self)
        //        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapContinue() {
        self.view.isUserInteractionEnabled = false
        guard itemImages.count > 0 else {
            self.showAlert(withMsg: "Please add at least 1 image!")
            self.view.isUserInteractionEnabled = true
            return
        }
        
        guard let category = itemCategory else {
            self.showAlert(withMsg: "Please select a Category!")
            self.view.isUserInteractionEnabled = true
            return
        }
        
        guard let subCategory = itemSubCategory else {
            self.showAlert(withMsg: "Please select a sub category!")
            self.view.isUserInteractionEnabled = true
            return
        }
        
        if subCategory.id == "" {
            self.showAlert(withMsg: "Please select a sub category!")
            self.view.isUserInteractionEnabled = true
            return
        }
        
        guard let itemName = itemTitle, itemName != "" else {
            self.showAlert(withMsg: "Please select Item Name!")
            self.view.isUserInteractionEnabled = true
            return
        }
        
        guard let itemNameAr = itemTitleAr, itemName != "" else {
            self.showAlert(withMsg: "Please select Item Name in arabic!")
            self.view.isUserInteractionEnabled = true
            return
        }

        guard let description = itemDescription, description != "" else {
            self.showAlert(withMsg: "Please add Description!")
            self.view.isUserInteractionEnabled = true
            return
        }

        
        guard let descriptionAr = itemDescriptionAr, description != "" else {
            self.showAlert(withMsg: "Please add Description in arabic!")
            self.view.isUserInteractionEnabled = true
            return
        }

        
        let arr = self.postItem?.medias.map({
            return $0.id
        })
        if arr?.count == 0 {
            self.showAlert(withMsg: "Please add any images!")
            self.view.isUserInteractionEnabled = true
            return
        }

        
        if (self.postItem?.id.count ?? 0 > 0) {
            
            switch postBaseType {
            case .normalSelling:
                if itemVariants.count == 0 && self.arrVariant.count == 0 {
                    guard let price = itemPrice else {
                        self.showAlert(withMsg: "Please add Price!")
                        self.view.isUserInteractionEnabled = true
                        return
                    }
                    
                    guard let quantity = itemQuantity else {
                        self.showAlert(withMsg: "Please add Quantity!")
                        self.view.isUserInteractionEnabled = true
                        return
                    }
                }
                
                Service.shared.updatePostDetails(forPost: self.postItem?.id ?? "", about: description, location: descriptionAr, cateId: category.id, subCateId: subCategory.id, quantity: self.itemQuantity ?? 0, title: itemName, titleAr: itemNameAr, price: itemPrice ?? 0, media: arr ?? []) { isTrue, msg in
                    self.showAlert(withMsg: "Post Updated successfully!")
                    self.view.isUserInteractionEnabled = true
                    self.handleDismiss()
                }
                
            case .normalBidding, .liveBidding:
                guard let price = itemPrice else {
                    self.showAlert(withMsg: "Please add Initial Price!")
                    self.view.isUserInteractionEnabled = true
                    return
                }
                Service.shared.updatePostDetails(forPost: self.postItem?.id ?? "", about: description, location: descriptionAr, cateId: category.id, subCateId: subCategory.id, quantity: self.itemQuantity ?? 0, title: itemName, titleAr: itemNameAr, price: itemPrice ?? 0, media: arr ?? []) { isTrue, msg in
                    self.showAlert(withMsg: "Post Updated successfully!")
                    self.view.isUserInteractionEnabled = true
                    self.handleDismiss()
                }
            }
        } else {
            
            switch postBaseType {
            case .normalSelling:
                if itemVariants.count == 0 && self.arrVariant.count == 0 {
                    guard let price = itemPrice else {
                        self.showAlert(withMsg: "Please add Price!")
                        self.view.isUserInteractionEnabled = true
                        return
                    }
                    
                    guard let quantity = itemQuantity else {
                        self.showAlert(withMsg: "Please add Quantity!")
                        self.view.isUserInteractionEnabled = true
                        return
                    }
                }
                
                Service.shared.uploadPost(ofType: postBaseType, allImages: itemImages, category: category, title: itemName, details: description, detailAr: descriptionAr, price: itemPrice ?? 0, quantity: itemQuantity ?? 0, variants: itemVariants, arrVariant: self.arrVariant, itemSub: subCategory, titleAr: itemNameAr) { status, message in
                    self.view.isUserInteractionEnabled = true
                    if status {
                        //                    self.showAlert(withMsg: "SUCCESS!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.handleDismiss()
                        }
                    } else {
                        guard let message = message else { return }
                        self.showAlert(withMsg: "FAILED!: \(message)")
                    }
                }
            case .normalBidding:
                guard let price = itemPrice else {
                    self.showAlert(withMsg: "Please add Initial Price!")
                    self.view.isUserInteractionEnabled = true
                    return
                }
                
                guard let itemStartDate = itemStartDate else {
                    self.showAlert(withMsg: "Please add Start Date!")
                    self.view.isUserInteractionEnabled = true
                    return
                }
                
                guard let duration = duration else {
                    self.showAlert(withMsg: "Please select Duration!")
                    self.view.isUserInteractionEnabled = true
                    return
                }
                
                var time : Int = 0
                switch (duration) {
                case .oneHour :
                    time = 60
                    break
                case .twoHour :
                    time = 120
                    break
                case .twelveHour :
                    time = 720
                    break
                case .twentyfourHour :
                    time = 1440
                    break
                case .twoDays :
                    time = 2880
                    break
                case .threeDays :
                    time = 4320
                    break
                case .fourDays :
                    time = 5760
                    break
                case .fiveDays :
                    time = 7200
                    break
                }
                
                Service.shared.uploadAuction(ofType: postBaseType, allImages: itemImages, category: category, title: itemName, details: description, initialPrice: price, startDate: itemStartDate, duration: time, itemSub: subCategory, titleAr: itemNameAr) { status, message in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.view.isUserInteractionEnabled = true
                        self.handleDismiss()
                    }
                }
                
            case .liveBidding:
                guard let price = itemPrice else {
                    self.showAlert(withMsg: "Please add Initial Price!")
                    self.view.isUserInteractionEnabled = true
                    return
                }
                
                guard let itemStartDate = itemStartDate else {
                    self.showAlert(withMsg: "Please add Start Date!")
                    self.view.isUserInteractionEnabled = true
                    return
                }
                
                Service.shared.uploadAuction(ofType: postBaseType, allImages: itemImages, category: category, title: itemName, details: description, initialPrice: price, startDate: itemStartDate, duration: 1440, itemSub: subCategory, titleAr: itemNameAr) { status, message in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.view.isUserInteractionEnabled = true
                        self.handleDismiss()
                    }
                }
            }
        }
    }
}

//MARK: - Delegate AuctionDurationPickerDelegate
extension CreateController: AuctionDurationPickerDelegate {
    func auctionDurationPicker(_ AuctionDurationPicker: AuctionDurationPicker, didSelectDuration duration: AuctionDuration) {
        self.duration = duration
        dismissPicker()
    }
}

extension CreateController : SubCategoryAddedDelegate {
    func subCategoryAdded(cate: ItemSubCategory) {
        itemSubCategory = cate
    }
}


extension CreateController : AddVariantDelegate {
    func sendVariant(arr: [VariantObject]) {
        self.arrVariant = []
        self.arrVariant = arr
    }
}
