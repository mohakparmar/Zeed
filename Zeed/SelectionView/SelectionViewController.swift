//
//  SelectionViewController.swift
//  Post
//
//  Created by hemant agarwal on 20/01/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit
import CoreLocation

protocol SelectionControllerDelegate {
    func finishPassing(string: String, SelectionType: Int, object:Any)

}

class SelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var objState : AddressState?
    
    // MARK: - View Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: title, preferredLargeTitle: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        

        tblSelection.registerNib(nibName: "SelectionTCell")
        
        if selectionType == 0 {
            self.title = "Select Governorate"
            Utility.openScreenView(str_screen_name: "Select_Governorate", str_nib_name: self.nibName ?? "")
        } else if selectionType == 1 {
            self.title = "Select Area"
            Utility.openScreenView(str_screen_name: "Select_Area", str_nib_name: self.nibName ?? "")
        } else if selectionType == 2 {
            self.title = "Select Category"
            Utility.openScreenView(str_screen_name: "Select_Category", str_nib_name: self.nibName ?? "")
        }
            
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }

    // MARK: - ButtonClicks
    @IBAction func btnBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneClick(_ sender: Any) {
        
    }
    

    // MARK: - Tableview Delegate and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForSelection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SelectionTCell = tblSelection.dequeueReusableCell(withIdentifier: "cell") as! SelectionTCell
        
        if selectionType == 0 {
            let obj = arrForSelection[indexPath.row] as! AddressState
            cell.lblTitle.text = obj.name
        } else if selectionType == 1 {
            let obj = arrForSelection[indexPath.row] as! AddressCity
            cell.lblTitle.text = obj.name
        } else if selectionType == 2 {
            let obj = arrForSelection[indexPath.row] as! ItemCategory
            cell.lblTitle.text = obj.name
        }
            
        cell.imgRound.setRadius(radius: cell.imgRound.viewHeightBy2)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionType == 0  {
            let obj = arrForSelection[indexPath.row] as! AddressState
            self.delegate?.finishPassing(string: obj.name , SelectionType: selectionType, object: obj)
            self.dismiss(animated: true, completion: nil)
        } else if selectionType == 1 {
            let obj = arrForSelection[indexPath.row] as! AddressCity
            self.delegate?.finishPassing(string: obj.name , SelectionType: selectionType, object: obj)
            self.dismiss(animated: true, completion: nil)
        } else if selectionType == 2 {
            let obj = arrForSelection[indexPath.row] as! ItemCategory
            self.delegate?.finishPassing(string: obj.name , SelectionType: selectionType, object: obj)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - WSCalls
    func getData() {
        if selectionType == 0 {
            Service.shared.getAllStates { arr, isTrue, str in
                if isTrue == true {
                    self.arrForSelection = arr ?? []
                }
            }
        } else if selectionType == 1 {
            Service.shared.getAllCities(stateId: objState?.id ?? "") { arr, isTrue, str in
                if isTrue == true {
                    self.arrForSelection = arr ?? []
                }
            }
        } else if selectionType == 2 {
            Service.shared.getAllCategories { (allCategories, status, message) in
                if status {
                    guard let allCategories = allCategories else { return }
                    self.arrForSelection = allCategories
                }
            }
        }
    }

    // MARK: - Variables and Other Declarations
    @IBOutlet weak var lblAddMoreChannel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var tblSelection: UITableView!
    
    var selectionType:Int = 0

    var arrForSelection:[Any] = [] {
        didSet {
            self.tblSelection.reloadData()
        }
    }
    
    var delegate : SelectionControllerDelegate? = nil
    let locationManager = CLLocationManager()
    var myLocation:Bool = true

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
