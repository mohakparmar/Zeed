//
//  MyProductListingTCell.swift
//  Zeed
//
//  Created by Mohak Parmar on 26/03/22.
//

import UIKit

class MyProductListingTCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var lblProdTitle: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var switchOnOff: UISwitch!
    @IBOutlet weak var btnEdit: UIButton!
    
    var objItem : PostItem? {
        didSet {
            imgVIew.layer.cornerRadius = 5
            btnEdit.layer.cornerRadius = 5
            
            lblProdTitle.text = objItem?.title
            lblShopName.text = objItem?.owner.userName
            lblDesc.text = objItem?.about
            if objItem?.medias.count ?? 0 > 0 {
                imgVIew.setImageUsingUrl(objItem?.medias[0].url)
            }
            switchOnOff.isOn = objItem?.isActive ?? false
            viewMain.setBorder(colour: "EFEFEF", alpha: 1, radius: 10, borderWidth: 1)
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

    var switchValueChange : (() -> ()) = {}
    @IBAction func switchValueChange(_ sender: Any) {
        switchValueChange()
    }
    
    var btnEditClick : (() -> ()) = {}
    @IBAction func btnEditClick(_ sender: Any) {
        btnEditClick()
    }
}
