//
//  SubCategoryTCell.swift
//  Zeed
//
//  Created by Mohak Parmar on 01/10/22.
//

import UIKit

class SubCategoryTCell: UITableViewCell {

    
    @IBOutlet weak var lblSubCategory: UILabel!
    
    var itemSub : ItemSubCategory? {
        didSet {
            lblSubCategory.text = itemSub?.nameEn ?? ""
            if lblSubCategory.text == "" {
                lblSubCategory.text = appDele!.isForArabic ? Select_Sub_Category_ar : Select_Sub_Category_en
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var btnPlusClick : (() -> ()) = {}
    @IBAction func btnPlusClick(_ sender: Any) {
        btnPlusClick()
    }
}
