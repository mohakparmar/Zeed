//
//  TermsViewController.swift
//  Zeed
//
//  Created by Mohak Parmar on 23/01/22.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var txtDetails: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WSForTerms()
        
        Utility.openScreenView(str_screen_name: "Terms_And_Conditions", str_nib_name: self.nibName ?? "")

        self.title = "Terms and conditions"

        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: title, preferredLargeTitle: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)

        // Do any additional setup after loading the view.
    }
    
    func WSForTerms() {
        let params: Dictionary<String, String> = [:]
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSForTerms, parameters: params, isPost: false) { (isSuccess, dict) in
            Utility.hideHud()
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if let arr = dict!["data"] as? String {
                        self.txtDetails.text = arr
                    }
                } else if str == 0 {
                    
                }
            }
        }
    }

    //MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    //MARK: - Selectors
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }


}
