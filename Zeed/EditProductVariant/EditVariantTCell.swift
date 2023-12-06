//
//  EditVariantTCell.swift
//  Zeed
//
//  Created by Mohak Parmar on 26/03/22.
//

import UIKit

class EditVariantTCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTItle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblAtt1Title: UILabel!
    @IBOutlet weak var lblAtt1Body: UILabel!
    
    @IBOutlet weak var lblAtt2Title: UILabel!
    @IBOutlet weak var lblAtt2Body: UILabel!
    
    @IBOutlet weak var lblQtyTitle: UILabel!
    @IBOutlet weak var txtQty: UITextField!
    
    @IBOutlet weak var btnUpdate: UIButton!
    var btnUpdateClick: (() -> ()) = {}
    @IBAction func btnUpdateClick(_ sender: Any) {
        btnUpdateClick()
    }
    
    @IBOutlet weak var btnDelete: UIButton!
    var btnDeleteClick: (() -> ()) = {}
    @IBAction func btnDeleteClick(_ sender: Any) {
        btnDeleteClick()
    }
    
    @IBOutlet weak var btnVar1: UIButton!
    var btnVar1Click: (() -> ()) = {}
    @IBAction func btnVar1Click(_ sender: Any) {
        btnVar1Click()
    }
    
    @IBOutlet weak var btnVar2: UIButton!
    var btnVar2Click: (() -> ()) = {}
    @IBAction func btnVar2Click(_ sender: Any) {
        btnVar2Click()
    }
    
    var objItem : ItemVariant? {
        didSet {
            lblPrice.text = String(format: "%.3f KWD", objItem?.price ?? 0)
            txtQty.text = "\(objItem?.quantity ?? 0)"
            
            if objItem?.attributes.count ?? 0 > 0 {
                if let obj = objItem?.attributes[0].newAtt {
                    lblAtt1Title.text = obj.name
                    lblAtt1Body.text = obj.selectedOption?.name
                } else {
                    lblAtt1Title.text = objItem?.attributes[0].type.name
                    lblAtt1Body.text = objItem?.attributes[0].option.name
                }
            }
            
            if objItem?.attributes.count ?? 0 > 1 {
                if let obj = objItem?.attributes[1].newAtt {
                    lblAtt2Title.text = obj.name
                    lblAtt2Body.text = obj.selectedOption?.name
                } else {
                    lblAtt2Title.text = objItem?.attributes[1].type.name
                    lblAtt2Body.text = objItem?.attributes[1].option.name
                }
            }
            
            
            btnUpdate.layer.cornerRadius = 5
            btnDelete.layer.cornerRadius = 5
            viewMain.setBorder(colour: "EFEFEF", alpha: 1, radius: 10, borderWidth: 1)
            lblTItle.text = (lblAtt1Body.text ?? "") +  " " + (lblAtt2Body.text ?? "")
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
    
}
