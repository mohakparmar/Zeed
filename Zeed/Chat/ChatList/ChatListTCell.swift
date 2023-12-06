//
//  ChatListTCell.swift
//  FFlash
//
//  Created by hemant agarwal on 24/02/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class ChatListTCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgVisable: UIImageView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    
    var btnMenuClick : (() -> ()) = {}
    
    @IBAction func btnMenuClick(_ sender: Any) {
        btnMenuClick()
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
