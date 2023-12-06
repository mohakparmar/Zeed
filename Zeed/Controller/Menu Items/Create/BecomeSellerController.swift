//
//  BecomeSellerController.swift
//  Zeed
//
//  Created by Shrey Gupta on 17/08/21.
//

import UIKit
import JGProgressHUD

enum BecomeSellerSections: Int, CaseIterable {
    case shopName
    case businessType
    case civilId
    case shopAddress
    case uploadLicense
    case bankName
    case IBANNumber
    case termsAndConditions
    case register
    
    var description: String {
        switch self {
        case .shopName:
            return appDele!.isForArabic ? Shop_Name_ar : Shop_Name_en
        case .businessType:
            return appDele!.isForArabic ? Business_Type_ar : Business_Type_en
        case .civilId:
            return appDele!.isForArabic ? Civil_ID_ar : Civil_ID_en
        case .shopAddress:
            return appDele!.isForArabic ? Shop_Address_ar : Shop_Address_en
        case .uploadLicense:
            return appDele!.isForArabic ? Upload_Licence_Mandatory_for_store_ar : Upload_Licence_Mandatory_for_store_en
        case .bankName:
            return appDele!.isForArabic ? Bank_Name_ar : Bank_Name_en
        case .IBANNumber:
            return appDele!.isForArabic ? IBAN_Number_ar : IBAN_Number_en
        case .termsAndConditions:
            return ""
        case .register:
            return ""
        }
    }
    
    var height: CGFloat {
        switch self {
        case .shopName:
            return 50
        case .businessType:
            return 60
        case .civilId:
            return 50
        case .shopAddress:
            return 50
        case .uploadLicense:
            return 50
        case .bankName:
            return 50
        case .IBANNumber:
            return 50
        case .termsAndConditions:
            return 55
        case .register:
            return 60
        }
    }
}


protocol BecomeSellerDelegate {
    func successBecomeASeller()
}

class BecomeSellerController: UITableViewController {
    //MARK: - Properties
    var hud = JGProgressHUD(style: .dark)
    
    var registerSellerObj = RegisterSellerInfo()
    var delegate:BecomeSellerDelegate?
    var licenseImage: UIImage? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tncAgreed: Bool = false
    
    private let imagePicker = UIImagePickerController()
    
    //MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        button.tintColor = .appPrimaryColor
        
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        Utility.openScreenView(str_screen_name: "Become_Seller", str_nib_name: self.nibName ?? "")

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: appDele!.isForArabic ? Become_a_Seller_ar : Become_a_Seller_en, preferredLargeTitle: false)
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        tableView.register(BecomeSellerTextFieldCell.self, forCellReuseIdentifier: BecomeSellerTextFieldCell.reuseIdentifier)
        tableView.register(BecomeSellerBusinessTypeCell.self, forCellReuseIdentifier: BecomeSellerBusinessTypeCell.reuseIdentifier)
        tableView.register(BecomeSellerUploadLicenseCell.self, forCellReuseIdentifier: BecomeSellerUploadLicenseCell.reuseIdentifier)
        tableView.register(BecomeSellerTnCCell.self, forCellReuseIdentifier: BecomeSellerTnCCell.reuseIdentifier)
        tableView.register(BecomeSellerRegisterCell.self, forCellReuseIdentifier: BecomeSellerRegisterCell.reuseIdentifier)
        
        configureUI()
        setupToHideKeyboardOnTapOnView()
    }
    
    //MARK: - Selectors
    @objc func handleDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        tableView.backgroundColor = .appBackgroundColor
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return BecomeSellerSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionTypeText = BecomeSellerSections(rawValue: section)?.description else { return nil }
        
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
        let sectionType = BecomeSellerSections(rawValue: section)!
        
        if sectionType == .termsAndConditions || sectionType == .register {
            return 0
        }
        return 28
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = BecomeSellerSections(rawValue: indexPath.section)!
        return sectionType.height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = BecomeSellerSections(rawValue: indexPath.section)!
        
        switch sectionType {
        case .shopName:
            let cell = tableView.dequeueReusableCell(withIdentifier: BecomeSellerTextFieldCell.reuseIdentifier, for: indexPath) as! BecomeSellerTextFieldCell
            cell.cellType = sectionType
            cell.delegate = self
            cell.text = self.registerSellerObj.shopName
            return cell
        case .businessType:
            let cell = tableView.dequeueReusableCell(withIdentifier: BecomeSellerBusinessTypeCell.reuseIdentifier, for: indexPath) as! BecomeSellerBusinessTypeCell
            cell.delegate = self
            cell.selectionStyle = .none
            cell.selectedStoreType = registerSellerObj.type
            return cell
        case .civilId:
            let cell = tableView.dequeueReusableCell(withIdentifier: BecomeSellerTextFieldCell.reuseIdentifier, for: indexPath) as! BecomeSellerTextFieldCell
            cell.textFeild.keyboardType = .numberPad
            cell.cellType = sectionType
            cell.delegate = self
            cell.text = self.registerSellerObj.civilId

            return cell
        case .shopAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: BecomeSellerTextFieldCell.reuseIdentifier, for: indexPath) as! BecomeSellerTextFieldCell
            cell.cellType = sectionType
            cell.delegate = self
            cell.text = self.registerSellerObj.address

            return cell
        case .uploadLicense:
            let cell = tableView.dequeueReusableCell(withIdentifier: BecomeSellerUploadLicenseCell.reuseIdentifier, for: indexPath) as! BecomeSellerUploadLicenseCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.isImageSelected = licenseImage != nil
            return cell
        case .bankName:
            let cell = tableView.dequeueReusableCell(withIdentifier: BecomeSellerTextFieldCell.reuseIdentifier, for: indexPath) as! BecomeSellerTextFieldCell
            cell.cellType = sectionType
            cell.delegate = self
            cell.text = self.registerSellerObj.bankName
            return cell
        case .IBANNumber:
            let cell = tableView.dequeueReusableCell(withIdentifier: BecomeSellerTextFieldCell.reuseIdentifier, for: indexPath) as! BecomeSellerTextFieldCell
            cell.textFeild.keyboardType = .numberPad
            cell.cellType = sectionType
            cell.delegate = self
            cell.text = self.registerSellerObj.IBAN
            return cell
        case .termsAndConditions:
            let cell = tableView.dequeueReusableCell(withIdentifier: BecomeSellerTnCCell.reuseIdentifier, for: indexPath) as! BecomeSellerTnCCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .register:
            let cell = tableView.dequeueReusableCell(withIdentifier: BecomeSellerRegisterCell.reuseIdentifier, for: indexPath) as! BecomeSellerRegisterCell
            cell.delegate = self
            return cell
        }
    }
}

//MARK: - Delegate BecomeSellerTextFieldCellDelegate
extension BecomeSellerController: BecomeSellerTextFieldCellDelegate {
    func didChangeText(text: String, onCellType cellType: BecomeSellerSections) {
        switch cellType {
        case .shopName:
            self.registerSellerObj.shopName = text
        case .civilId:
            self.registerSellerObj.civilId = text
        case .shopAddress:
            self.registerSellerObj.address = text
        case .bankName:
            self.registerSellerObj.bankName = text
        case .IBANNumber:
            self.registerSellerObj.IBAN = text
        default:
            break
        }
    }
}

//MARK: - Delegate BecomeSellerBusinessTypeCell
extension BecomeSellerController: BecomeSellerBusinessTypeCellDelegate {
    func didSelectStoreType(type: RegisterSellerType) {
        self.registerSellerObj.type = type
    }
}

//MARK: - Delegate
extension BecomeSellerController: BecomeSellerUploadLicenseCellDelegate {
    func didTapSelectImage() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didTapRemoveImage() {
        licenseImage = nil
    }
}

//MARK: - Delegate BecomeSellerRegisterCellDelegate
extension BecomeSellerController: BecomeSellerRegisterCellDelegate {
    func didTapRegister() {
        guard registerSellerObj.shopName != "" else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_your_shop_name_ar : Please_enter_your_shop_name_en)
            return
        }
        
        guard registerSellerObj.civilId != "" else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_a_valid_civil_id_number_of_12_digits_ar : Please_enter_a_valid_civil_id_number_of_12_digits_en )
            return
        }
        
        guard registerSellerObj.address != "" else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_your_shop_address_ar : Please_enter_your_shop_address_en)
            return
        }
        
        if registerSellerObj.type == .store {
            guard licenseImage != nil else {
                self.showAlert(withMsg: appDele!.isForArabic ? Please_upload_your_shop_license_to_enroll_as_a_seller_on_our_platform_ar : Please_upload_your_shop_license_to_enroll_as_a_seller_on_our_platform_en)
                return
            }
        }
        
        guard registerSellerObj.bankName != "" else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_bank_name_ar : Please_enter_bank_name_en)
            return
        }
        
        guard registerSellerObj.IBAN != "" else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_IBAN_Number_ar : Please_enter_IBAN_Number_en)
            return
        }
        
        guard tncAgreed else {
            self.showAlert(withMsg: "You need to agree to TnC to continue.")
            return
        }
        
        hud.show(in: self.view, animated: true)
        Service.shared.registerSeller(info: registerSellerObj, licenseImage: licenseImage) { status, message in
            self.hud.dismiss(animated: true)
            if status {
                guard var currentUser = AppUser.shared.getDefaultUser() else { return }
                currentUser.isSeller = true
                
                let _ = AppUser.shared.setDefaultUser(user: currentUser)
                
                Utility.showISMessage(str_title: "Success!", Message: "Now you're a seller and you can start posting. ", msgtype: .success, duration: 3) {
                    self.handleDismiss()
                    self.delegate?.successBecomeASeller()
                }
            }
        }
    }
}

//MARK: - Delegate UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension BecomeSellerController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        licenseImage = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Delegate
extension BecomeSellerController: BecomeSellerTnCCellDelegate {
    func didtapOnLabel() {
        let controller = TermsViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func didTapTnC(isAgreed: Bool) {
        self.tncAgreed = isAgreed
    }
}
