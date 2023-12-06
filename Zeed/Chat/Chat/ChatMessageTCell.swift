//
//  ChatMessageTCell.swift
//  FFlash
//
//  Created by hemant agarwal on 06/04/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class ChatMessageTCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellLayout(isForUser:Bool) {
        if isForUser {
            viewMain.transform = trnForm_Ar
            imgUser.transform = trnForm_Ar
            lblMessage.transform = trnForm_Ar
            lblName.transform = trnForm_Ar
            imgPlay.transform = trnForm_Ar
            viewAudio.transform = trnForm_Ar
            lblStoryMsg.transform = trnForm_Ar

            lblStoryMsg.textAlignment = .left
            lblAudioTitle.textAlignment = .right
            lblName.textAlignment = .right
            lblMessage.textAlignment = .right
            
        } else {
            viewMain.transform = trnForm_En

            imgPlay.transform = trnForm_En
            imgUser.transform = trnForm_En
            lblMessage.transform = trnForm_En
            lblName.transform = trnForm_En
            viewAudio.transform = trnForm_En
            lblStoryMsg.transform = trnForm_En

            lblStoryMsg.textAlignment = .right
            lblAudioTitle.textAlignment = .left
            lblName.textAlignment = .left
            lblMessage.textAlignment = .left
        }
    }
    
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgTextBG: UIImageView!
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var imgPlay: UIImageView!
    
    @IBOutlet weak var viewAudio: UIView!
    @IBOutlet weak var lblAudioTitle: UILabel!
    @IBOutlet weak var imgAudioPlay: UIImageView!
    @IBOutlet weak var lblStoryMsg: UILabel!
    @IBOutlet weak var viewStoryMsg: UIView!
    
}
