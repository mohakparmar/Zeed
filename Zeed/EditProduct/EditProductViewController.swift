//
//  EditProductViewController.swift
//  Zeed
//
//  Created by Mohak Parmar on 26/03/22.
//

import UIKit
import Alamofire
import Network

class EditProductViewController: UIViewController {

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var scrView: UIScrollView!
    
    @IBOutlet weak var lblUploadImageTitle: UILabel!
    @IBOutlet weak var collectionImage: UICollectionView!
    
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var txtCategory: UITextField!
    
    @IBOutlet weak var lblTitleEn: UILabel!
    @IBOutlet weak var txtTitleEn: UITextField!
    
    @IBOutlet weak var lblTitleAr: UILabel!
    @IBOutlet weak var txtTitleAr: UITextField!
    
    @IBOutlet weak var lblSelectTypeTItle: UILabel!
    @IBOutlet weak var btnFixed: UIButton!
    @IBOutlet weak var btnAuction: UIButton!
    @IBOutlet weak var btnLiveAuction: UIButton!
    
    @IBOutlet weak var lblDetailTitle: UILabel!
    @IBOutlet weak var txtDetails: UITextView!
    
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var viewQty: UIView!
    @IBOutlet weak var lblQuantityTitle: UILabel!
    @IBOutlet weak var txtQuantity: UITextField!
    
    var objItem : PostItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Edit_Product", str_nib_name: self.nibName ?? "")

        self.navigationItem.title = "My Product"
        collectionImage.registerNib(nibName: "BannerCCell")
        setData()
    }
    
    func setData() {
        txtCategory.text = objItem?.category.name
        txtTitleEn.text = objItem?.title
        txtTitleAr.text = objItem?.title_ar
        txtDetails.text = objItem?.about

        txtDetails.setBorder(colour: "EFEFEF", alpha: 1, radius: 10, borderWidth: 1)

        txtQuantity.text = "\(objItem?.quantity ?? 0)"
        txtPrice.text = "\(objItem?.price ?? 0)"

        if objItem?.variants.count ?? 0 > 0 {
            viewQty.isHidden = true
            viewPrice.isHidden = true
        }

        btnContinue.layer.cornerRadius = 5
        
        self.updateButton(btn: btnFixed)
        self.updateButton(btn: btnAuction)
        self.updateButton(btn: btnLiveAuction)

        if objItem?.postBaseType == .normalSelling {
            btnFixed.backgroundColor = UIColor.hex("007DA5")
            btnFixed.setTitleColor(.white, for: .normal)
            btnFixed.setBorder(colour: "EFEFEF", alpha: 1, radius: 10, borderWidth: 1)
        } else if objItem?.postBaseType == .normalBidding {
            btnAuction.backgroundColor = UIColor.hex("007DA5")
            btnAuction.setTitleColor(.white, for: .normal)
            btnAuction.setBorder(colour: "EFEFEF", alpha: 1, radius: 10, borderWidth: 1)
        } else if objItem?.postBaseType == .liveBidding {
            btnLiveAuction.backgroundColor = UIColor.hex("007DA5")
            btnLiveAuction.setTitleColor(.white, for: .normal)
            btnLiveAuction.setBorder(colour: "EFEFEF", alpha: 1, radius: 10, borderWidth: 1)
        }
    }
    
    func updateButton(btn : UIButton) {
        btn.setTitleColor(UIColor.hex("007DA5"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.setBorder(colour: "EFEFEF", alpha: 1, radius: 10, borderWidth: 1)
    }

    @IBAction func btnContinueClick(_ sender: Any) {
        updatePost()
    }

    func updatePost() {
        if objItem?.category.id.checkEmpty() ?? false {
            self.showAlert(withMsg: appDele!.isForArabic ? Select_Category_ar : Select_Category_en)
        } else if txtTitleEn.text?.checkEmpty() ?? false {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_product_title_ar : Please_enter_product_title_en)
        } else if txtTitleAr.text?.checkEmpty() ?? false {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_product_title_ar : Please_enter_product_title_ar)
        } else if txtPrice.text?.checkEmpty() ?? false && viewPrice.isHidden == false {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_product_price_ar : Please_enter_product_price_en)
        } else if txtQuantity.text?.checkEmpty() ?? false && viewQty.isHidden == false {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_available_quantity_ar : Please_enter_available_quantity_en)
        } else {
            var param : Parameters = [:]
            param["type"] = objItem?.type.rawValue ?? ""
            param["about"] = txtDetails.text ?? ""
            param["categoryId"] = objItem?.category.id ?? ""
            param["title"] = txtTitleEn.text ?? ""
            param["title_ar"] = txtTitleAr.text ?? ""
            param["postBaseType"] = objItem?.postBaseType.rawValue ?? ""

            param["quantity"] = txtQuantity.text ?? ""
            param["price"] = txtPrice.text ?? ""
            param["postId"] = objItem?.id ?? ""

            var allMedia = [String]()
            if let arr = objItem?.medias {
                for index in 0 ..< arr.count {
                    allMedia.append(arr[index].id)
                }
            }
            param["media"] = allMedia
            
            var request = URLRequest(url: URL(string: REF_POST_UPDATE)!)
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
    
    @IBAction func btnCategoryClick(_ sender: Any) {
        let obj = SelectionViewController()
        obj.selectionType = 2
        obj.delegate = self
        self.present(obj, animated: true, completion: nil)
    }
}

extension EditProductViewController : SelectionControllerDelegate {
    func finishPassing(string: String, SelectionType: Int, object: Any) {
        objItem?.category = object as! ItemCategory
        txtCategory.text = objItem?.category.name
    }
}


extension EditProductViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCCell
        if (objItem?.medias.count ?? 0) > indexPath.row {
            let obj = objItem?.medias[indexPath.row]
            cell.imgView.setImage(url: obj?.url ?? "")
            cell.imgView.contentMode = .scaleAspectFill
        } else {
            cell.imgView.image = UIImage(named: "add_image")
            cell.imgView.contentMode = .scaleToFill
        }
        
        cell.imgView.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - 50) / 5, height: collectionView.height)
    }
}

