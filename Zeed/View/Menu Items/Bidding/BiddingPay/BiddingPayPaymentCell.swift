//
//  BiddingPayPaymentCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 03/04/21.
//

import UIKit

protocol BiddingPaySectionsTypesDelegate: AnyObject {
    func getPaymentMethod(paymentMethod method: BiddingPayPaymentTypes)
}


enum BiddingPayPaymentTypes: String, CaseIterable {
    case knet = "knet"
    case creditCard = "creditCard"
    case wallet = "wallet"
    
    var description: String {
        switch self {
        case .knet:
            return "Knet"
        case .creditCard:
            return "Credit Card"
        case .wallet:
            return "Wallet"
        }
    }
    
    var image: UIImage {
        switch self {
        case .knet:
            return #imageLiteral(resourceName: "knet").withRenderingMode(.alwaysOriginal)
        case .creditCard:
            return #imageLiteral(resourceName: "credit_card").withRenderingMode(.alwaysOriginal)
        case .wallet:
            return #imageLiteral(resourceName: "wallet-1").withRenderingMode(.alwaysOriginal)
        }
    }
}

class BiddingPayPaymentCell: UITableViewCell {
    //MARK: - Properties
    var tableView: UITableView
    
    var lastSelection: IndexPath?
    
    var balance : String? {
        didSet {
            tableView.reloadData()
        }
    }

    weak var delegate: BiddingPaySectionsTypesDelegate?

    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        tableView = UITableView(frame: .zero)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BiddingPayPaymentTypeCell.self, forCellReuseIdentifier: BiddingPayPaymentTypeCell.reuseIdentifier)
        
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
        tableView.fillSuperview(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
    }
}
extension BiddingPayPaymentCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BiddingPayPaymentTypes.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BiddingPayPaymentTypeCell.reuseIdentifier, for: indexPath) as! BiddingPayPaymentTypeCell
        cell.type = BiddingPayPaymentTypes.allCases[indexPath.row]
        if BiddingPayPaymentTypes.allCases[indexPath.row] == .wallet {
            cell.typeLabel.text = BiddingPayPaymentTypes.allCases[indexPath.row].description + " \(self.balance ?? "0") \(appDele!.isForArabic ? KWD_ar : KWD_en)"
        }
        return cell
    }
}

extension BiddingPayPaymentCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.lastSelection != nil {
            self.tableView.cellForRow(at: self.lastSelection!)?.accessoryType = .none
        }

        self.delegate?.getPaymentMethod(paymentMethod: BiddingPayPaymentTypes.allCases[indexPath.row])
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        self.lastSelection = indexPath

        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

