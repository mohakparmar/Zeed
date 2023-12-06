//
//  EditProductVariantVC.swift
//  Zeed
//
//  Created by Mohak Parmar on 26/03/22.
//

import UIKit
import Alamofire
import Network

class EditProductVariantVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var lblProdTitle: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var switchOnOff: UISwitch!
    @IBOutlet weak var btnEdit: UIButton!
    
    var objItem : PostItem?
    @IBOutlet weak var tblVarient: UITableView!
    @IBOutlet weak var btnAddVariant: UIButton!
    
    @IBOutlet weak var viewAddVariant: UIView!
    @IBOutlet weak var lblVariant1TItle: UILabel!
    @IBOutlet weak var lblVariant1Name: UILabel!
    
    @IBOutlet weak var lblVariant2TItle: UILabel!
    @IBOutlet weak var lblVariant2Name: UILabel!
    
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var btnAddNewVariant: UIButton!
    var fetchedAttributes = [ItemAttribute]()
    var attributePicker = AttributePicker()
    var blackView = UIView()
    
    var att1: ItemAttribute? {
        didSet {
            lblVariant1TItle.text = att1?.name
            lblVariant1Name.text = att1?.selectedOption?.name
        }
    }
    
    var att2: ItemAttribute? {
        didSet {
            lblVariant2TItle.text = att2?.name
            lblVariant2Name.text = att2?.selectedOption?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Edit_Profile", str_nib_name: self.nibName ?? "")

        tblVarient.registerNib(nibName: "EditVariantTCell")
        attributePicker.delegate = self
        
        Service.shared.fetchAllAttributes { allAttributes, status, message in
            if status {
                guard let allAttributes = allAttributes else { return }
                self.fetchedAttributes = allAttributes
            } else {
                
            }
        }
        setData()
    }
    
    
    func setData() {
        imgVIew.layer.cornerRadius = 5
        btnEdit.layer.cornerRadius = 5
        btnAddVariant.layer.cornerRadius = 5
        btnAddNewVariant.layer.cornerRadius = 5
        
        lblProdTitle.text = objItem?.title
        lblShopName.text = objItem?.owner.userName
        lblDesc.text = objItem?.about
        if objItem?.medias.count ?? 0 > 0 {
            imgVIew.setImageUsingUrl(objItem?.medias[0].url)
        }
        switchOnOff.isOn = objItem?.isActive ?? false
        viewMain.setBorder(colour: "EFEFEF", alpha: 1, radius: 10, borderWidth: 1)
    }
    
    @IBAction func btnAddVariantClick(_ sender: Any) {
        viewAddVariant.isHidden = false
    }
    
    @IBAction func btnEditClick(_ sender: Any) {
        let obj = EditProductViewController()
        obj.objItem = objItem
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnAddNewVariantClick(_ sender: Any) {
        addNewVariant()
        viewAddVariant.isHidden = true
    }
    
    @IBAction func btnHideVariantClick(_ sender: Any) {
        viewAddVariant.isHidden = true
    }
    
    @IBAction func btnVar1Click(_ sender: Any) {
        bringAttributePicker(forIndexPath: IndexPath(row: 0, section: 0), forVariantType: .variantOne)
    }
    
    @IBAction func btnVar2Click(_ sender: Any) {
        bringAttributePicker(forIndexPath: IndexPath(row: 0, section: 0), forVariantType: .variantTwo)
    }
    
    func addNewVariant() {
        if att1?.id.checkEmpty() ?? true {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_select_at_least_1_attribute_for_your_post_variants_ar : Please_select_at_least_1_attribute_for_your_post_variants_en)
        } else if att2?.id.checkEmpty() ?? true {
            self.showAlert(withMsg: "Please select second attributes.")
        } else if txtQty.text?.checkEmpty() ?? false {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_available_quantity_ar : Please_enter_available_quantity_en)
        } else if txtPrice.text?.checkEmpty() ?? false {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_product_price_ar : Please_enter_product_price_en)
        } else {
            var param : Parameters = [:]
            param["postId"] = objItem?.id ?? ""
            var variant : Parameters = [:]
            variant["price"] = txtPrice.text ?? ""
            variant["quantity"] = txtQty.text ?? ""
            variant["attributes"] = [["attributeId": att1!.id , "attributeOptionId" : (att1!.selectedOption?.id ?? "")], ["attributeId": att2!.id, "attributeOptionId" : (att2!.selectedOption?.id ?? "")]]
            param["variants"] = [variant]
            
            print(param)
            var request = URLRequest(url: URL(string: REF_VARIANT_ADD)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
            let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
            AF.request(request).responseJSON { (response) in
                let jsonData = response.value as! [String: Any]
                print(jsonData)
                let status = jsonData["status"] as? Bool ?? false
                if status == true {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func updateVariant(objI : ItemVariant) {
        var param : Parameters = [:]
        param["variantId"] = objI.id
        param["price"] = objI.price
        param["quantity"] = objI.quantity
        var newVari1 : Parameters = [:]
        newVari1["oldAttributeId"] = objI.attributes[0].option.attributeId
        newVari1["newAttributeId"] = objI.attributes[0].option.attributeId

        newVari1["oldAttributeOptionId"] = objI.attributes[0].option.id
        if let a1 = objI.attributes[0].newAtt {
            newVari1["newAttributeOptionId"] = a1.selectedOption?.id ?? ""
        } else {
            newVari1["newAttributeOptionId"] = objI.attributes[0].option.id
        }
        
        var newVari2 : Parameters = [:]
        newVari2["oldAttributeId"] = objI.attributes[1].option.attributeId
        newVari2["newAttributeId"] = objI.attributes[1].option.attributeId

        newVari2["oldAttributeOptionId"] = objI.attributes[1].option.id

        if let a1 = objI.attributes[1].newAtt {
            newVari2["newAttributeOptionId"] = a1.selectedOption?.id ?? ""
        } else {
            newVari2["newAttributeOptionId"] = objI.attributes[1].option.id
        }
        param["variantAttributes"] = [newVari1, newVari2]
        
        print(param)
        var request = URLRequest(url: URL(string: REF_VARIANT_UPDATE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            if status == true {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func deleteVariant(objI : ItemVariant) {
        var param : Parameters = [:]
        param["variantId"] = objI.id
        var request = URLRequest(url: URL(string: REF_VARIANT_DELETE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            if status == true {

            }
        }
    }
    
    
    
    //MARK: - Selectors
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 0
            self.attributePicker.frame.origin.y = UIScreen.main.bounds.height
        } completion: { (_) in
            self.blackView.removeFromSuperview()
        }
    }
    
    func bringAttributePicker(forIndexPath indexPath: IndexPath, forVariantType variantType: VariantAttributeType) {
        attributePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.5)
        
        attributePicker.allAttributes = fetchedAttributes
        attributePicker.forIndexPath = indexPath
        attributePicker.forVariantType = variantType
        
        bringBlackView()
        
        UIApplication.shared.keyWindow?.addSubview(attributePicker)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 1
            self.attributePicker.frame.origin.y = UIScreen.main.bounds.height - (UIScreen.main.bounds.height/2.5)
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
    
}


extension EditProductVariantVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVarient.dequeueReusableCell(withIdentifier: "cell") as! EditVariantTCell
        cell.objItem = objItem?.variants[indexPath.row]
        
        cell.btnDeleteClick = {
            self.deleteVariant(objI: (self.objItem?.variants[indexPath.row])!)
            self.objItem?.variants.remove(at: indexPath.row)
            self.tblVarient.reloadData()
        }
        
        cell.btnUpdateClick = {
            cell.objItem!.quantity = Int(cell.txtQty.text ?? "0") ?? 0
            self.updateVariant(objI: cell.objItem!)
        }
        
        cell.btnVar1Click = {
            self.bringAttributePicker(forIndexPath: indexPath, forVariantType: .variantOne)
        }
        
        cell.btnVar2Click = {
            self.bringAttributePicker(forIndexPath: indexPath, forVariantType: .variantTwo)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objItem?.variants.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
}


extension EditProductVariantVC: AttributePickerDelegate {
    func attributePicker(_ attributePicker: AttributePicker, didSelectAttribute attribute: ItemAttribute, atIndexPath indexPath: IndexPath, forVariantType: VariantAttributeType) {
        
        switch forVariantType {
        case .variantOne:
            if viewAddVariant.isHidden == true {
                if attribute.selectedOption?.parentAttributeId == objItem?.variants[indexPath.row].attributes[1].option.attributeId {
                    self.showAlert(withMsg: appDele!.isForArabic ? You_cannot_select_same_attribute_type_for_both_variants_ar : You_cannot_select_same_attribute_type_for_both_variants_en, forTime: 0.8)
                } else {
                    objItem?.variants[indexPath.row].attributes[0].newAtt = attribute
                    self.tblVarient.reloadRows(at: [indexPath], with: .fade)
                }
            } else {
                if attribute.selectedOption?.parentAttributeId == att2?.selectedOption?.parentAttributeId {
                    self.showAlert(withMsg: appDele!.isForArabic ? You_cannot_select_same_attribute_type_for_both_variants_ar : You_cannot_select_same_attribute_type_for_both_variants_en, forTime: 0.8)
                } else {
                    att1 = attribute
                }
            }
            break
        case .variantTwo:
            if viewAddVariant.isHidden == true {
                if attribute.selectedOption?.parentAttributeId == objItem?.variants[indexPath.row].attributes[0].option.attributeId {
                    self.showAlert(withMsg: appDele!.isForArabic ? You_cannot_select_same_attribute_type_for_both_variants_ar : You_cannot_select_same_attribute_type_for_both_variants_en, forTime: 0.8)
                } else {
                    objItem?.variants[indexPath.row].attributes[1].newAtt = attribute
                    self.tblVarient.reloadRows(at: [indexPath], with: .fade)
                }
            } else {
                if attribute.selectedOption?.parentAttributeId == att1?.selectedOption?.parentAttributeId {
                    self.showAlert(withMsg: appDele!.isForArabic ? You_cannot_select_same_attribute_type_for_both_variants_ar : You_cannot_select_same_attribute_type_for_both_variants_en, forTime: 0.8)
                } else {
                    att2 = attribute
                }
            }
            break
        }
        dismissPicker()
    }
}
