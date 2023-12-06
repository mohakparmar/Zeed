//
//  SelectionTCell.swift
//  Post
//
//  Created by hemant agarwal on 20/01/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class SelectionTCell: UITableViewCell {

    
    @IBOutlet weak var imgRound: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSep: UIView!
    @IBOutlet weak var lblLang: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
