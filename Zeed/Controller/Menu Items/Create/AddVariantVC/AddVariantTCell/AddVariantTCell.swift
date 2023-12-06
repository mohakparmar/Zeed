//
//  AddVariantTCell.swift
//  Zeed
//
//  Created by Mohak Parmar on 05/10/22.
//

import UIKit

class AddVariantTCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblVar1EngTitle: UILabel!
    @IBOutlet weak var lblVar1ArTitle: UILabel!
    @IBOutlet weak var lblVar2EngTitle: UILabel!
    @IBOutlet weak var lblVar2ArTitle: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblKWD: UILabel!
    @IBOutlet weak var lblQuantityTitle: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var txtVar1Eng: UITextField!
    @IBOutlet weak var txtVar1Ar: UITextField!
    @IBOutlet weak var txtVar2Eng: UITextField!
    @IBOutlet weak var txtVar2Ar: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var btnRemoveClick : (() -> ()) = {}
    @IBAction func btnRemoveClick(_ sender: Any) {
        btnRemoveClick()
    }
}
