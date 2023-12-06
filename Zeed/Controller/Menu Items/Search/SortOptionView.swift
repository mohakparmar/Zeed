//
//  SortOptionView.swift
//  Zeed
//
//  Created by Mohak Parmar on 24/06/23.
//

import UIKit

class SortOptionView: UIView {
    
    @IBOutlet weak var btnHideView: UIButton!
    @IBOutlet weak var btnHighToLow: UIButton!
    @IBOutlet weak var btnLowToHigh: UIButton!
    @IBOutlet weak var viewMain: UIView!
    
    
    var btnHideViewClick: (() -> ()) = {}
    @IBAction func btnHideViewClick(_ sender: Any) {
        btnHideViewClick()
    }

    var btnHighToLowClick: (() -> ()) = {}
    @IBAction func btnHighToLowClick(_ sender: Any) {
        btnHighToLowClick()
    }
    
    var btnLowToHighClick: (() -> ()) = {}
    @IBAction func btnLowToHighClick(_ sender: Any) {
        btnLowToHighClick()
    }
    
    
    static func instantiate(frame: CGRect) -> SortOptionView {
        let view: SortOptionView = initFromNib()
        view.btnHighToLow.setTitle(appDele!.isForArabic ? "السعر من الاعلى الى الاقل" : "Price High to Low", for: .normal)
        view.btnLowToHigh.setTitle(appDele!.isForArabic ? "السعر من الاقل الى الاعلى" : "Price Low to High", for: .normal)
        view.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height - 100)
        view.viewMain.setRadius(radius: 20)
        return view
    }
}

