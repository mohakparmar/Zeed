//
//  MenuTCell.swift
//  FFlash
//
//  Created by hemant agarwal on 20/02/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class MenuTCell: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSep: UIView!
    @IBOutlet weak var imgLocation: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
