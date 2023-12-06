//
//  KnetViewController.swift
//  Post
//
//  Created by hemant agarwal on 04/04/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit
import WebKit

class KnetViewController: UIViewController, WKNavigationDelegate {

    var paymentMethod: String = ""
    var isForCart : Bool = false
    var isForBiddingPay : Bool = false
    var objCart : CartPurchaseBlock?
    var objItem : ItemPurchaseData?
    
    var dictForCartItem : [String:Any] = [:]
    var dictForBidding : [String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "KNET_Payment", str_nib_name: self.nibName ?? "")

        if isForCart == true {
            strPaymentyUrl = objCart?.objPaymentData.PaymentURL ?? ""
        } else {
            strPaymentyUrl = objItem?.objPayment?.PaymentURL ?? ""
        }
        request()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = paymentMethod
    }
    

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let strMain = webView.url?.absoluteString
        print(strMain)
        if strMain?.contains("purchase/success-callback") ?? false {
            let paymentId = webView.url?.valueOf("paymentId")
            if isForCart {
                Service.shared.addPurchaseSuccesFailureForCart(paymentId: paymentId ?? "", isSuccess: true, dict: dictForCartItem) { isSuccess in
                    if isSuccess {
                        Utility.Purchased(transaction_id: self.objCart?.objPaymentData.InvoiceId ?? "", content_type: "Product", productPrice: "\(self.objCart?.amount ?? "")", item_id: "")
                        self.navigateToThankYouWithResult(result: true)
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } else {
                Service.shared.addPurchaseSuccesFailureForCart(paymentId: paymentId ?? "", isSuccess: true, dict: dictForBidding) { isSuccess in
                    if isSuccess {
                        self.navigateToThankYouWithResult(result: true)
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        } else if strMain?.contains("purchase/failed-callback") ?? false {
            let paymentId = webView.url?.valueOf("paymentId")
            Service.shared.addPurchaseSuccesFailure(paymentId: paymentId ?? "", isSuccess: false, dict: dictForBidding) { isSuccess in
                if isSuccess {
                    self.navigateToThankYouWithResult(result: false)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func navigateToThankYouWithResult(result:Bool) {
        if result == true {
            if isForCart {
                self.navigationController?.pushViewController(CartThankyouController(purchaseInfo: objCart!, isSuccess: result), animated: true)
            } else {
                let obj = BiddingThankyouController(forPurchase: objItem!, isSuccess: result)
                obj.isForBiddingPay = self.isForBiddingPay
                self.navigationController?.pushViewController(obj, animated: true)
            }
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            self.navigationController?.popViewController(animated:false)
        }
    }

    @objc func request() {
        webViewKnet.navigationDelegate = self
        print(strPaymentyUrl)
        if strPaymentyUrl.checkEmpty() {
            
        } else {
            let url = URL(string: strPaymentyUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let post: String = ""
            let postData: Data = post.data(using: String.Encoding.ascii, allowLossyConversion: true)!
            
            request.httpBody = postData
            webViewKnet.load(request as URLRequest)
        }
    }

    
    @IBOutlet weak var webViewKnet: WKWebView!
    var strPaymentyUrl:String = ""
    var strRemainigAmount:String = ""
    var strCampaignId:String = ""
    var strTransactionId:String = ""
    var isAdvance:Bool = false
    var isFinal:Bool = false
    var isOutdoorCheck:Bool = false

}

