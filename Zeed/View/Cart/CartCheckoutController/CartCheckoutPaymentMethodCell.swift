//
//  CartCheckoutPaymentMethodCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 08/04/21.
//

import UIKit

protocol CartCheckoutPaymentMethodTypesDelegate: AnyObject {
    func getPaymentMethod(paymentMethod method: CartCheckoutPaymentMethodTypes)
}


enum CartCheckoutPaymentMethodTypes: Int, CaseIterable {
    case knet
    case creditCard
    case applePay
    case wallet
    
    var description: String {
        switch self {
        case .knet:
            return appDele!.isForArabic ? Knet_ar : Knet_en
        case .creditCard:
            return appDele!.isForArabic ? Credit_Card_ar : Credit_Card_en
        case .applePay:
            return appDele!.isForArabic ? apple_pay_ar : apple_pay_en
        case .wallet:
            return appDele!.isForArabic ? Wallet_ar : Wallet_en
        }
    }
    
    var image: UIImage {
        switch self {
        case .knet:
            return #imageLiteral(resourceName: "knet").withRenderingMode(.alwaysOriginal)
        case .creditCard:
            return #imageLiteral(resourceName: "credit_card").withRenderingMode(.alwaysOriginal)
        case .applePay:
            return UIImage(named: "apple_black")!.withRenderingMode(.alwaysOriginal)
        case .wallet:
            return #imageLiteral(resourceName: "wallet-1").withRenderingMode(.alwaysOriginal)
        }
    }
}

class CartCheckoutPaymentMethodCell: UITableViewCell {
    //MARK: - Properties
    var tableView: UITableView
    
    var lastSelection: IndexPath?
    weak var delegate: CartCheckoutPaymentMethodTypesDelegate?
    
    var cartTotal:String?
    var balance:String? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        tableView = UITableView(frame: .zero)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CartCheckoutPaymentMethodTypeCell.self, forCellReuseIdentifier: CartCheckoutPaymentMethodTypeCell.reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        
        tableView.separatorStyle = .none
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        selectionStyle = .none
        
        tableView.backgroundColor = .white
        
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.addShadow()
        
        contentView.addSubview(tableView)
        tableView.fillSuperview(padding: UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15))
    }
}
extension CartCheckoutPaymentMethodCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CartCheckoutPaymentMethodTypes.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCheckoutPaymentMethodTypeCell.reuseIdentifier, for: indexPath) as! CartCheckoutPaymentMethodTypeCell
        cell.type = CartCheckoutPaymentMethodTypes.allCases[indexPath.row]
        
        if cell.type == .wallet {
            cell.typeLabel.text = (cell.type?.description ?? "") + " : \(balance ?? "0") \(appDele!.isForArabic ? KWD_ar : KWD_en)"
        }
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        if #available(iOS 13.0, *) {
            imgView.image = UIImage(systemName: "checkmark")!
            imgView.tintColor = .appColor
            if appDele!.isForArabic {
                imgView.transform = trnForm_Ar;
            }
        }
        cell.accessoryView = imgView
        
        if self.lastSelection == indexPath {
            cell.accessoryView?.isHidden = false
//            cell.accessoryType = .checkmark
        } else {
            cell.accessoryView?.isHidden = true
//            cell.accessoryType = .none
        }

        
        return cell
    }
}

extension CartCheckoutPaymentMethodCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if CartCheckoutPaymentMethodTypes.allCases[indexPath.row] == .wallet && (cartTotal?.floatValue ?? 0) > (balance?.floatValue ?? 0) {
            Utility.showISMessage(str_title: "", Message: "You do not have sufficient balance to do this transaction via wallet.", msgtype: .warning)
        } else {
            self.lastSelection = indexPath
            self.tableView.reloadData()
            self.delegate?.getPaymentMethod(paymentMethod: CartCheckoutPaymentMethodTypes.allCases[indexPath.row])
        }
    }
}
