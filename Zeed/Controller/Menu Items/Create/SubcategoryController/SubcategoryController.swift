//
//  SubcategoryController.swift
//  Zeed
//
//  Created by Mohak Parmar on 01/10/22.
//

import UIKit
import JGProgressHUD

protocol SubCategoryAddedDelegate {
    func subCategoryAdded(cate:ItemSubCategory)
}

class SubcategoryController: UIViewController {


    
    @IBOutlet weak var txtEnglish: UITextField!
    @IBOutlet weak var txtArabic: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var cateogry : ItemCategory = ItemCategory(dict: [:])
    var hud = JGProgressHUD(style: .dark)
    var delegate : SubCategoryAddedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Utility.openScreenView(str_screen_name: "Sub_Category_List", str_nib_name: self.nibName ?? "")

        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: appDele!.isForArabic ? Sub_Category_ar : Sub_Category_en, preferredLargeTitle: false)
        
        btnSave.setbuttonBdr(radius: 5)
        
        if appDele!.isForArabic  {
            txtEnglish.placeholder = "أدخل اسم الفئة الفرعية بالإنجليزية"
            txtArabic.placeholder = "أدخل اسم الفئة الفرعية بالعربية"
            txtEnglish.textAlignment = .right
            txtArabic.textAlignment = .right
            btnSave.setTitle("حفظ", for: .normal)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        guard txtEnglish.text != "" else {
            self.showAlert(withMsg: "Please enter category name in English")
            return
        }
        
        guard txtArabic.text != "" else {
            self.showAlert(withMsg: "Please enter category name in Arabic")
            return
        }
        
        hud.show(in: self.view, animated: true)
        Service.shared.addNewCategory(cateId: cateogry.id,
                                      nameEn: txtEnglish.text!,
                                      nameAr: txtArabic.text!) { status, sub, message in
            self.hud.dismiss(animated: true)
            if status {
                self.showAlert(withMsg: "Category added successfully.")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.delegate?.subCategoryAdded(cate: sub ?? ItemSubCategory(dict: [:]))
                    self.navigationController?.popViewController(animated: true)
                })
            } else  {
                self.showAlert(withMsg: message)
            }
        }
    }
}
