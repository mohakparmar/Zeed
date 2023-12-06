//
//  AddAddressVC.swift
//  Zeed
//
//  Created by Mohak Parmar on 21/01/22.
//

import UIKit
import MapKit

class AddAddressVC: UIViewController {
    
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: title, preferredLargeTitle: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        Utility.openScreenView(str_screen_name: "Add_Address", str_nib_name: self.nibName ?? "")

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
            UINavigationBar.appearance().barStyle = .default
        }

        
        let navLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 10, height: view.frame.height))
        navLabel.textColor = .appPrimaryColor
        navLabel.font = UIFont.boldSystemFont(ofSize: 25)
        if address == nil {
            navLabel.text = appDele!.isForArabic ? Add_Address_ar : Add_Address_en
        } else {
            navLabel.text = appDele!.isForArabic ? Edit_Address_ar : Edit_Address_en
        }
        navLabel.textAlignment = appDele!.isForArabic ? .right : .left
        navigationItem.titleView = navLabel
        configureData()
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
            
            
            txtAddressName.placeholder = Address_Name_ar
            txtMobileNumber.placeholder = Mobile_Number_ar
            txtGovernorate.placeholder = Governorate_ar
            txtArea.placeholder = Area_ar
            txtBlock.placeholder = Block_ar
            txtStreet.placeholder = Street_ar
            txtAvenue.placeholder = Avenue_ar
            txtFloor.placeholder = Floor_Number_ar
            txtHouse.placeholder = House_Number_ar
            txtDirection.placeholder = Direction_ar
            lblSelectLocation.text = Select_Your_Location_ar
            txtApartment.placeholder = "شقة"
            btnSave.setTitle(Confirm_ar, for: .normal)
            
            
        }
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        if txtAddressName.text?.checkEmpty() == true {
            Utility.showISMessage(str_title: "Warning", Message: "Please enter address name.", msgtype: .error)
        } else if txtMobileNumber.text?.checkEmpty() == true {
            Utility.showISMessage(str_title: "Warning", Message: "Please enter mobile number.", msgtype: .error)
        } else if objGovernorate == nil {
            Utility.showISMessage(str_title: "Warning", Message: "Please select governorate.", msgtype: .error)
        } else if objArea == nil {
            Utility.showISMessage(str_title: "Warning", Message: "Please select area.", msgtype: .error)
        } else if txtBlock.text?.checkEmpty() == true {
            Utility.showISMessage(str_title: "Warning", Message: "Please enter block.", msgtype: .error)
        } else if txtStreet.text?.checkEmpty() == true {
            Utility.showISMessage(str_title: "Warning", Message: "Please enter street.", msgtype: .error)
//        } else if txtAvenue.text?.checkEmpty() == true {
//            Utility.showISMessage(str_title: "Warning", Message: "Please enter avenue.", msgtype: .error)
        } else if txtFloor.text?.checkEmpty() == true {
            Utility.showISMessage(str_title: "Warning", Message: "Please enter floor.", msgtype: .error)
        } else if txtHouse.text?.checkEmpty() == true {
            Utility.showISMessage(str_title: "Warning", Message: "Please enter house number.", msgtype: .error)
//        } else if txtDirection.text?.checkEmpty() == true {
//            Utility.showISMessage(str_title: "Warning", Message: "Please enter direction.", msgtype: .error)
        } else {
            let selectedCoordinates : SellingLocation = SellingLocation(title: "", coordinate: CLLocationCoordinate2D(latitude: strLat.doubleValue, longitude: strLng.doubleValue))
            if address == nil {
                Service.shared.addAddress(addressName: txtAddressName.text!, mobileNo: txtMobileNumber.text!, mobileAlternateNo: "", CityId: objArea?.id ?? "", label: typeOfAddress.rawValue, block: txtBlock.text!, street: txtStreet.text!, avenue: txtAvenue.text!, floor: txtFloor.text!, flat: txtHouse.text!, selectedCoordinates: selectedCoordinates, isDefault: true, direction: txtDirection.text ?? "", apartment: txtApartment.text ?? "") { status in
                    if status {
                        Utility.showISMessage(str_title: "Success", Message: "Address Added Successfully!", msgtype: .success)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        Utility.showISMessage(str_title: "Failed", Message: "Error occoured while creating address.", msgtype: .error)
                    }
                    self.handleDismiss()
                }
            } else {
                guard let address = address else { return }
                Service.shared.updateAddress(addressName: txtAddressName.text!, mobileNo: txtMobileNumber.text!, mobileAlternateNo: "", CityId: objArea?.id ?? "", label: typeOfAddress.rawValue, block: txtBlock.text!, street: txtStreet.text!, avenue: txtAvenue.text!, floor: txtFloor.text!, flat: txtHouse.text!, selectedCoordinates: selectedCoordinates, isDefault: true, addressId: address.id, direction: txtDirection.text ?? "", apartment: txtApartment.text ?? "") { status in
                    if status {
                        Utility.showISMessage(str_title: "Success", Message: "Address Edited Successfully!", msgtype: .success)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        Utility.showISMessage(str_title: "Failed", Message: "Error occoured while editing address.", msgtype: .error)
                    }
                    self.handleDismiss()
                }
            }
        }
    }
    
    @IBAction func btnHomeClick(_ sender: Any) {
        reSetButtons()
        imgHome.image = UIImage.init(named: "select")
        typeOfAddress = .home
    }
    
    @IBAction func btnWorkClick(_ sender: Any) {
        reSetButtons()
        imgWork.image = UIImage.init(named: "select")
        typeOfAddress = .work
    }
    
    @IBAction func btnOtherClick(_ sender: Any) {
        reSetButtons()
        imgOther.image = UIImage.init(named: "select")
        typeOfAddress = .other
    }
    
    func reSetButtons() {
        imgHome.image = UIImage.init(named: "unselect")
        imgWork.image = UIImage.init(named: "unselect")
        imgOther.image = UIImage.init(named: "unselect")
    }
    
    func configureData() {
        guard let address = address else { return }
        txtAddressName.text = address.name
        txtMobileNumber.text = address.mobileNumber
        txtBlock.text = address.block
        txtHouse.text = address.flat
        txtFloor.text = address.floor
        txtStreet.text = address.street
        txtAvenue.text = address.avenue
        txtDirection.text = address.direction
        objArea = address.city
        txtArea.text = objArea?.name
        txtGovernorate.text = objArea?.state.name
        objGovernorate = address.city.state
        typeOfAddress = address.addressType
        txtApartment.text = address.apartment
    }

    @IBAction func btnSelectLocationClick(_ sender: Any) {
        let obj = MapviewViewController()
        obj.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBOutlet weak var scrView: UIScrollView!
    
    @IBOutlet weak var viewHome: UIView!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var imgHome: UIImageView!
    
    @IBOutlet weak var viewWork: UIView!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var imgWork: UIImageView!
    
    @IBOutlet weak var viewOther: UIView!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var imgOther: UIImageView!
    
    @IBOutlet weak var txtAddressName: SGTextField!
    @IBOutlet weak var txtGovernorate: SGTextField!
    @IBOutlet weak var txtArea: SGTextField!
    @IBOutlet weak var txtBlock: SGTextField!
    @IBOutlet weak var txtStreet: SGTextField!
    @IBOutlet weak var txtAvenue: SGTextField!
    @IBOutlet weak var txtHouse: SGTextField!
    @IBOutlet weak var txtFloor: SGTextField!
    @IBOutlet weak var txtDirection: SGTextField!
    @IBOutlet weak var txtMobileNumber: SGTextField!
    @IBOutlet weak var lblSelectLocation: UILabel!
    @IBOutlet weak var txtApartment: SGTextField!
    
    
    var objGovernorate : AddressState?
    var objArea : AddressCity?
    var address: Address?

    var strLat:String = "0"
    var strLng:String = "0"

    var typeOfAddress: AddressType = AddressType.home

    //MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    //MARK: - Selectors
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension AddAddressVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtGovernorate == textField {
            let controller = SelectionViewController()
            controller.delegate = self
            controller.selectionType = 0
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            return false
        } else if txtArea == textField {
            if objGovernorate?.id == "" || objGovernorate?.id == nil {
                Utility.showISMessage(str_title: "Warning", Message: "Please select governorate.", msgtype: .error)
            } else {
                let controller = SelectionViewController()
                controller.delegate = self
                controller.selectionType = 1
                controller.objState = objGovernorate
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
            }
            return false
        }
        return true
    }
}

extension AddAddressVC : SelectionControllerDelegate {
    func finishPassing(string: String, SelectionType: Int, object: Any) {
        if SelectionType == 0 {
            txtGovernorate.text = string
            objGovernorate = (object as! AddressState)
            txtArea.text = ""
            objArea = nil
        } else if SelectionType == 1 {
            txtArea.text = string
            objArea = (object as! AddressCity)
        }
    }
}

extension AddAddressVC : MapViewDelegate {
    func getPlaceMark(placemark: CLPlacemark, latlng: CLLocationCoordinate2D) {
        if placemark.subLocality?.count ?? 0 > 0 {
            txtAvenue.text = placemark.subLocality ?? ""
        }
        if placemark.thoroughfare?.count ?? 0 > 0 {
            txtStreet.text = placemark.thoroughfare ?? ""
        }
        if placemark.subThoroughfare?.count ?? 0 > 0 {
            txtHouse.text = placemark.subThoroughfare ?? ""
        }
        strLat = "\(latlng.latitude)"
        strLng = "\(latlng.longitude)"
    }
    
    func getArea(areaName: String, latlng: CLLocationCoordinate2D) {
        
    }
    
    
}
