//
//  AddVariantVC.swift
//  Zeed
//
//  Created by Mohak Parmar on 05/10/22.
//

import UIKit

protocol AddVariantDelegate {
    func sendVariant(arr:[VariantObject])
}

class AddVariantVC: UIViewController {

    @IBOutlet weak var tblVariant: UITableView!
    @IBOutlet weak var btnAddNew: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    var postItem : PostItem?

    var arrVariant : [VariantObject] = []
    var delegate : AddVariantDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: appDele!.isForArabic ? "الانواع" : "Variants", preferredLargeTitle: false)
        tblVariant.register(UINib(nibName: "AddVariantTCell", bundle: nil), forCellReuseIdentifier: "AddVariantTCell")
        Utility.openScreenView(str_screen_name: "Add_variant", str_nib_name: self.nibName ?? "")

        if appDele!.isForArabic == true {
            btnDone.setTitle("اتمام", for: .normal)
            btnAddNew.setTitle("اضافة نوع جديد", for: .normal)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnDone.layer.cornerRadius = 5
        btnAddNew.layer.cornerRadius = 5
    }

    @IBAction func btnAddNewVariantClick(_ sender: Any) {
        arrVariant.append(VariantObject())
        self.tblVariant.reloadData()
    }
    
    @IBAction func btnDoneClick(_ sender: Any) {
        var isPending : Bool = false
        var isSecondVariantAdded : Bool = false

        for item in arrVariant {
            if item.strPrice == "" || item.strV1Ar == "" || item.strQuantity == "" || item.strV1Eng == "" {
                isPending = true
            }
            
        }

        let arrItem = arrVariant.filter({
            $0.strV2Eng != "" && $0.strV2Ar != ""
        })
        
        if arrItem.count > 0 && arrVariant.count != arrItem.count {
            isSecondVariantAdded = true
        }

        
        if arrVariant.count == 0 {
            self.showAlert(withMsg: "Please add a single variant to proceed.")
        } else if isPending == true {
            self.showAlert(withMsg: "Please add all the variant pending data.")
        } else if isSecondVariantAdded == true {
            self.showAlert(withMsg: "Please add all Variant 2 in the list.")
        } else {
            if self.postItem?.id.checkEmpty() == true || self.postItem?.id.checkEmpty() == nil{
                self.delegate?.sendVariant(arr: self.arrVariant)
                self.navigationController?.popViewController(animated: true)
            } else {
                updateVariant()
            }
        }
    }
    
    func updateVariant(isForDelete: Bool = false) {
        Service.shared.addVariantSaprately(forPostId: self.postItem?.id ?? "", arrVariant: self.arrVariant) { item, isTrue, strMsg in
            Service.shared.fetchPostDetailNormal(postId: self.postItem?.id ?? "", userId: "") { items, status, message in
                if status {
                    guard let items = items else { return }
                    if items.count > 0 {
                        self.postItem = items[0]
                        self.arrVariant = []
                        for item in self.postItem?.variants ?? [] {
                            let obj = VariantObject()
                            obj.strId = item.id
                            if item.attributes.count > 0 {
                                obj.strV2Eng = item.attributes[0].type.name
                                obj.strV2Ar = item.attributes[0].type.name_ar
                            }
                            if item.attributes.count > 1 {
                                obj.strV1Eng = item.attributes[1].type.name
                                obj.strV1Ar = item.attributes[1].type.name_ar
                            }
                            obj.strPrice = "\(item.price)"
                            obj.strQuantity = "\(item.quantity)"
                            self.arrVariant.append(obj)
                        }
                        self.delegate?.sendVariant(arr: self.arrVariant)
                        if isForDelete == false {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}

extension AddVariantVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddVariantTCell") as! AddVariantTCell
        
        cell.viewMain.layer.cornerRadius = 5;
        cell.viewMain.layer.masksToBounds = true
        
        let obj = self.arrVariant[indexPath.row]
        
        self.setTag(tag: indexPath.row, txt: cell.txtVar1Eng, index: 1)
        self.setTag(tag: indexPath.row, txt: cell.txtVar1Ar, index: 2)
        self.setTag(tag: indexPath.row, txt: cell.txtVar2Eng, index: 3)
        self.setTag(tag: indexPath.row, txt: cell.txtVar2Ar, index: 4)
        self.setTag(tag: indexPath.row, txt: cell.txtPrice, index: 5)
        self.setTag(tag: indexPath.row, txt: cell.txtQuantity, index: 6)
        
        cell.txtVar1Eng.text = obj.strV1Eng
        cell.txtVar2Eng.text = obj.strV2Eng
        cell.txtQuantity.text = obj.strQuantity
        cell.txtPrice.text = obj.strPrice
        cell.txtVar1Ar.text = obj.strV1Ar
        cell.txtVar2Ar.text = obj.strV2Ar
        
        cell.btnRemoveClick = {
            self.arrVariant.remove(at: indexPath.row)
            self.tblVariant.reloadData()
            if self.postItem?.id.checkEmpty() == true || self.postItem?.id.checkEmpty() == nil{

            } else {
                self.updateVariant(isForDelete:  true )
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVariant.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func setTag(tag:Int, txt:UITextField, index:Int) {
        txt.tag = ((tag + 1) * 10) +  index
        txt.delegate = self
    }
}

class VariantObject : NSObject {
    var strId : String = ""
    var strV1Eng : String = ""
    var strV1Ar : String = ""
    var strV2Eng : String = ""
    var strV2Ar : String = ""
    var strPrice : String = ""
    var strQuantity : String = ""
}

extension AddVariantVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = textField.tag / 10
        let indexForTxt = textField.tag % 10
            
        switch indexForTxt {
        case 1:
            arrVariant[index - 1].strV1Eng = textField.text ?? ""
            break
        case 2:
            arrVariant[index - 1].strV1Ar = textField.text ?? ""
            break
        case 3:
            arrVariant[index - 1].strV2Eng = textField.text ?? ""
            break
        case 4:
            arrVariant[index - 1].strV2Ar = textField.text ?? ""
            break
        case 5:
            arrVariant[index - 1].strPrice = textField.text ?? ""
            break
        case 6:
            arrVariant[index - 1].strQuantity = textField.text ?? ""
            break
        default:
            break

        }

    }
}
