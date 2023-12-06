//
//  PrivacyAlertView.swift
//  Zeed
//
//  Created by Mohak Parmar on 16/06/23.
//

import UIKit

class PrivacyAlertView: UIView {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewTopSep: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnHide: UIButton!
    
    var btnPublicClick: (() -> ()) = {}
    @IBAction func btnPublicClick(_ sender: Any) {
        btnPublicClick()
    }
    
    var btnHideClick: (() -> ()) = {}
    @IBAction func btnHideClick(_ sender: Any) {
        btnHideClick()
    }
    
    static func instantiate(title: String, alertText: String, btnName: String, frame: CGRect) -> PrivacyAlertView {
        let view: PrivacyAlertView = initFromNib()
        view.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height - 100)
        view.lblTitle.text = title
        view.lblDescription.text = alertText
        view.btnPublic.setTitle(btnName, for: .normal)
        view.viewMain.setRadius(radius: 20)
        view.viewTopSep.setRadius(radius: 5)
        view.btnPublic.setRadius(radius: 27.5)
        
        if appDele!.isForArabic {
            view.lblTitle.transform = trnForm_Ar;
            view.lblDescription.transform = trnForm_Ar;
            view.lblDescription.textAlignment = .right;
            view.btnPublic.transform = trnForm_Ar;
            view.imgLogo.transform = trnForm_Ar;
        }
        return view
    }

    
}


extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
