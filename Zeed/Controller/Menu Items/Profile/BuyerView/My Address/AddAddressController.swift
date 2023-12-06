//
//  AddAddressController.swift
//  Fortune
//
//  Created by Shrey Gupta on 29/12/20.
//

import UIKit
import MapKit

enum AddAddressControllerItems: String, CaseIterable {
    case contactInfo = "Info"
    case addressDetails = "Address Details"
    case typeOfAddress = "Type of Address"
    
    var cellSize: CGFloat {
        switch self {
        case .contactInfo:
            return 220
        case .addressDetails:
            return 380
        case .typeOfAddress:
            return 130
        }
    }
}

class AddAddressController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var address: Address?
    
    private let locationManager = LocationHandler.shared.locationManager
    
    var isDataUpdated: Bool = true
    
    //MARK: - Variables
    var addressName: String? {
        didSet {
            isDataUpdated = true
        }
    }
    
    var mobileNo: String? {
        didSet {
            isDataUpdated = true
        }
    }
    
    var mobileAlternateNo: String? {
        didSet {
            isDataUpdated = true
        }
    }
    
    var addressLane1Text: String? {
        didSet {
            isDataUpdated = true
        }
    }
    
    var addressLane2Text: String? {
        didSet {
            isDataUpdated = true
        }
    }
    
    var landmark: String? {
        didSet {
            isDataUpdated = true
        }
    }
    
    var selectedCoordinates: SellingLocation? {
        didSet {
            isDataUpdated = true
        }
    }
    
    var selectedCity: AddressCity? {
        didSet {
            isDataUpdated = true
        }
    }
    
    var selectedDesc: String? {
        didSet {
            isDataUpdated = true
        }
    }
    
    var typeOfAddress: AddressType? {
        didSet {
            isDataUpdated = true
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
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.appPrimaryColor
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(editAddress address: Address? = nil) {
        self.address = address
        print("DEBUG:- did set address")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(collectionViewLayout: layout)
        if address == nil {
            self.title = "Add Address"
        } else {
            self.title = "Edit Address"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: title, preferredLargeTitle: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        Utility.openScreenView(str_screen_name: "Add_Address", str_nib_name: self.nibName ?? "")

        collectionView.register(ContactInfoAddAddressCell.self, forCellWithReuseIdentifier: ContactInfoAddAddressCell.reuseIdentifier)
        collectionView.register(AddressDetailsAddAddressCell.self, forCellWithReuseIdentifier: AddressDetailsAddAddressCell.reuseIdentifier)
        collectionView.register(TypeOfAddressAddAddressCell.self, forCellWithReuseIdentifier: TypeOfAddressAddAddressCell.reuseIdentifier)
        
        configureUI()
        setupToHideKeyboardOnTapOnView()
        enableLocationServices()
        getAllCities()
        configureData()
    }
    
    func configureData() {
        guard let address = address else { return }
        addressName = address.name
        mobileNo = address.mobileNumber
        mobileAlternateNo = address.alternateMobileNumber
        let coordinates = SellingLocation(title: "", coordinate: CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude))
        addressLane1Text = address.addressLine1
        addressLane2Text = address.addressLine2
        landmark = address.landmark
        selectedCoordinates = coordinates
        selectedDesc = address.direction
        selectedCity = address.city
        typeOfAddress = address.addressType
    }
    
    //MARK: - Selectors
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var arrForCities : [AddressCity] = []
    func getAllCities() {
        Service.shared.getAllCities(stateId: "") { arr, isTrue, str in
            if isTrue == true {
                self.arrForCities = arr ?? []
            }
        }
    }
    
    @objc func handleSave() {
        if isDataUpdated {
            guard let addressName = addressName else {
                Utility.showISMessage(str_title: "Warning", Message: "Please enter address name.", msgtype: .error)
                return }
            guard let mobileNo = mobileNo else {
                Utility.showISMessage(str_title: "Warning", Message: "Please enter mobile number.", msgtype: .error)
                return }
            guard let mobileAlternateNo = mobileAlternateNo else {
                Utility.showISMessage(str_title: "Warning", Message: "Please enter alertnate number.", msgtype: .error)
                return }
            guard let addressLane1Text = addressLane1Text else {
                Utility.showISMessage(str_title: "Warning", Message: "Please enter address line 1.", msgtype: .error)
                return }
            guard let addressLane2Text = addressLane2Text else {
                Utility.showISMessage(str_title: "Warning", Message: "Please enter address line 2.", msgtype: .error)
                return }
            let selectedCoordinates : SellingLocation = SellingLocation(title: "", coordinate: CLLocationCoordinate2D(latitude: 22.444, longitude: 72.4455))
            guard let selectedCity = selectedCity else {
                Utility.showISMessage(str_title: "Warning", Message: "Please select city.", msgtype: .error)
                return }
            guard let typeOfAddress = typeOfAddress else {
                Utility.showISMessage(str_title: "Warning", Message: "Please select address type.", msgtype: .error)
                return }
            
//            if address == nil {
//                Service.shared.addAddress(addressName: addressName, mobileNo: mobileNo, mobileAlternateNo: mobileAlternateNo, addressLane1Text: addressLane1Text, addressLane2Text: addressLane2Text, landmark: landmark ?? "", selectedCoordinates: selectedCoordinates, selectedCity: selectedCity, selectedDesc: selectedDesc ?? "", typeOfAddress: typeOfAddress, isDefault: false) { status in
//                    if status {
//                        Utility.showISMessage(str_title: "Success", Message: "Address Added Successfully!", msgtype: .success)
//                        self.navigationController?.popViewController(animated: true)
//                    } else {
//                        Utility.showISMessage(str_title: "Failed", Message: "Error occoured while creating address.", msgtype: .error)
//                    }
//                    self.handleDismiss()
//                }
//            } else {
//                guard let address = address else { return }
//                Service.shared.updateAddress(withAddressId: address.id, addressName: addressName, mobileNo: mobileNo, mobileAlternateNo: mobileAlternateNo, addressLane1Text: addressLane1Text, addressLane2Text: addressLane2Text, landmark: landmark ?? "", selectedCoordinates: selectedCoordinates, selectedCity: selectedCity, selectedDesc: selectedDesc ?? "", typeOfAddress: typeOfAddress, isDefault: false) { status in
//                    if status {
//                        Utility.showISMessage(str_title: "Success", Message: "Address Edited Successfully!", msgtype: .success)
//                    } else {
//                        Utility.showISMessage(str_title: "Failed", Message: "Error occoured while editing address.", msgtype: .error)
//                    }
//                    self.handleDismiss()
//                }
//            }
        }
    }
    
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .backgroundWhiteColor
        
        view.addSubview(saveButton)
        saveButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 55)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: saveButton.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
        
        let colorView = UIView()
        colorView.backgroundColor = .appPrimaryColor
        view.addSubview(colorView)
        colorView.anchor(top: saveButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func enableLocationServices(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: not determined")
            locationManager!.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            locationManager!.startUpdatingLocation()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: authorized when in use")
            locationManager!.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    //MARK: - DataSource & Delegate UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AddAddressControllerItems.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType = AddAddressControllerItems.allCases[indexPath.row]
        return CGSize(width: view.frame.width - 20, height: cellType.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = AddAddressControllerItems.allCases[indexPath.row]
        
        switch cellType {
        case .contactInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactInfoAddAddressCell.reuseIdentifier, for: indexPath) as! ContactInfoAddAddressCell
            cell.addressName = addressName
            cell.mobileNo = mobileNo
            cell.alternateMobileNo = mobileAlternateNo
            cell.titleLabel.text = AddAddressControllerItems.allCases[indexPath.row].rawValue
            cell.delegate = self
            return cell
        case .addressDetails:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressDetailsAddAddressCell.reuseIdentifier, for: indexPath) as! AddressDetailsAddAddressCell
            cell.titleLabel.text = AddAddressControllerItems.allCases[indexPath.row].rawValue
            cell.selectedAddressLane1 = addressLane1Text
            cell.selectedAddressLane2 = addressLane2Text
            cell.landmark = landmark
            cell.selectedCoordinate = selectedCoordinates
            cell.selectedCity = selectedCity
            cell.selectedDesc = selectedDesc
            cell.delegate = self
            return cell
        case .typeOfAddress:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeOfAddressAddAddressCell.reuseIdentifier, for: indexPath) as! TypeOfAddressAddAddressCell
            cell.titleLabel.text = AddAddressControllerItems.allCases[indexPath.row].rawValue
            cell.typeOfAddress = typeOfAddress
            cell.delegate = self
            return cell
        }
    }
}

//MARK: - Delegate ContactInfoAddAddressCellDelegate
extension AddAddressController: ContactInfoAddAddressCellDelegate  {
    func didUpdateAddressName(withText text: String) {
        addressName = text
    }
    
    func didUpdateMobileNo(withNo num: String) {
        mobileNo = num
    }
    
    func didUpdateAlternateMobileNo(withNo num: String) {
        mobileAlternateNo = num
    }
}


//MARK: - Delegate TypeOfAddressAddAddressCellDelegate
extension AddAddressController: TypeOfAddressAddAddressCellDelegate {
    func didSelectTypeOfAdress(type: AddressType) {
        typeOfAddress = type
    }
}

//MARK: - Delegate AddressDetailsAddAddressCellDelegate
extension AddAddressController: AddressDetailsAddAddressCellDelegate {
    func didUpdateAddressLane1(with text: String) {
        addressLane1Text = text
    }
    
    func didUpdateAddressLane2(with text: String) {
        addressLane2Text = text
    }
    
    func didUpdateLandmark(with text: String) {
        landmark = text
    }
    
    func didTapSelectCity() {
        if arrForCities.count > 0 {
            let arrCi = self.arrForCities.map({ $0.name })
            let alert = UIAlertController(title: "Select City", message: "", preferredStyle: .actionSheet)
            selectedCity = arrForCities[0]
            alert.addPickerView(values: arrCi) { vc, picker, index, values in
                let arr = self.arrForCities.filter({ $0.name == arrCi[index.row] })
                if arr.count > 0 {
                    self.selectedCity = arr[0]
                    self.collectionView.reloadData()
                }
            }
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { alert in
                self.collectionView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        print("DEBUG:- didTapSelectCity")
    }
    
    func didTapSelectLocation() {
        let controller = SelectLocationController()
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didChangeDirection(with text: String) {
        selectedDesc = text
    }
}

//MARK: - Delegate SelectLocationControllerDelegate
extension AddAddressController: SelectLocationControllerDelegate {
    func updateLocation(location: SellingLocation) {
        self.selectedCoordinates = location
    }
}
