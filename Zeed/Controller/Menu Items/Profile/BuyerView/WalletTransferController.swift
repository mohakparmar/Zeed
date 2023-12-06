//
//  WalletTransferController.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/04/21.
//

import Foundation
import UIKit

enum WalletTransferControllerSections: Int, CaseIterable {
    case amount
    case bankName
    case ibanNumber
    case summary
    case confirm
    
    var description: String {
        switch self {
        case .amount:
            return appDele!.isForArabic ? Amount_ar : Amount_en
        case .bankName:
            return appDele!.isForArabic ? Bank_Name_ar : Bank_Name_en
        case .ibanNumber:
            return appDele!.isForArabic ? IBAN_Number_ar : IBAN_Number_en
        case .summary:
            return ""
        case .confirm:
            return ""
        }
    }
    
    var height: CGFloat {
        switch self {
        case .amount:
            return CGFloat(50)
        case .bankName:
            return CGFloat(50)
        case .ibanNumber:
            return CGFloat(50)
        case .summary:
            return CGFloat(185)
        case .confirm:
            return CGFloat(50)
        }
    }
}

class WalletTransferController: UITableViewController {
    //MARK: - Properties

    //MARK: - Item Details
    var transferAmount: Double?
    
    var transferBankName: String?
    
    var IBANNumber: String?

    
    //MARK: - UI Elements

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = appDele!.isForArabic ? Transfer_ar : Transfer_en
        Utility.openScreenView(str_screen_name: "Wallet_Transfer", str_nib_name: self.nibName ?? "")

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .appBackgroundColor), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .appPrimaryColor
        self.navigationController?.navigationBar.barTintColor = .appBackgroundColor

        
        tableView.backgroundColor = .appBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        tableView.register(WalletTransferAmountCell.self, forCellReuseIdentifier: WalletTransferAmountCell.reuseIdentifier)
        tableView.register(WalletTransferBankTransferCell.self, forCellReuseIdentifier: WalletTransferBankTransferCell.reuseIdentifier)
        tableView.register(WalletTransferIBANCell.self, forCellReuseIdentifier: WalletTransferIBANCell.reuseIdentifier)
        tableView.register(WalletTransferSummaryCell.self, forCellReuseIdentifier: WalletTransferSummaryCell.reuseIdentifier)
        tableView.register(WalletTransferConfirmCell.self, forCellReuseIdentifier: WalletTransferConfirmCell.reuseIdentifier)
        
        configureUI()
        setupToHideKeyboardOnTapOnView()
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }

        self.WSForTransferAmountInWallet()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        })
    }
    
    //MARK: - Selectors
    var balance : String = ""
    var availableAmount : String = ""
    func WSForTransferAmountInWallet() {
        var dictParam : [String:Any] = [:]
        dictParam["userId"] = loggedInUser?.id
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSGetSingleUser, parameters: dictParam, isPost: true) { isError, dict in
            print(dict)
            if isError == false {
                if let str = dict?["walletBalance"]  {
                    self.balance = "\(str)"
                    self.availableAmount = "\(str)"
                    self.transferAmount = Double(self.balance ) ?? 0
                    self.tableView.reloadData()
                }
            } 
        }
    }

    func WSForTransferAmount() {
        var dictParam : [String:Any] = [:]
        dictParam["subTotal"] = self.transferAmount
        dictParam["serviceCharge"] = "0"
        dictParam["total"] = self.transferAmount
        dictParam["bankName"] = self.transferBankName
        dictParam["IBAN"] = self.IBANNumber
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSForTrasferToBank, parameters: dictParam, isPost: true) { isError, dict in
            print(dict)
            if isError == false {
                self.navigationController?.popViewController(animated: true)
                self.showAlert(withMsg: "Amount transfer to bank successfully.")
            }
        }
    }
    
    //MARK: - Helper Funtions
    func configureUI() {
        tableView.backgroundColor = .appBackgroundColor
    }

    
    //MARK: - DataSource & Delegate UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return WalletTransferControllerSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = WalletTransferControllerSections(rawValue: section)!
        
        let customView = UIView()
        customView.backgroundColor = .appBackgroundColor
        customView.alpha = 0.7
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = sectionType.description
        
        customView.addSubview(label)
        label.anchor(left: customView.leftAnchor, right: customView.rightAnchor, paddingLeft: 10, paddingRight: 10)
        label.centerY(inView: customView)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: customView)
        }

        return customView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = WalletTransferControllerSections(rawValue: section)!
        if sectionType == .summary || sectionType == .confirm {
            return 0
        } else {
            return 28
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = WalletTransferControllerSections(rawValue: indexPath.section)!
        return sectionType.height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = WalletTransferControllerSections(rawValue: indexPath.section)!
        
        switch sectionType {
        case .amount:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletTransferAmountCell.reuseIdentifier, for: indexPath) as! WalletTransferAmountCell
            cell.amount = String(format: "%.3f", self.transferAmount ?? 0)
            cell.delegate = self
            return cell
        case .bankName:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletTransferBankTransferCell.reuseIdentifier, for: indexPath) as! WalletTransferBankTransferCell
            cell.delegate = self
            return cell
        case .ibanNumber:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletTransferIBANCell.reuseIdentifier, for: indexPath) as! WalletTransferIBANCell
            cell.delegate = self
            return cell
        case .summary:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletTransferSummaryCell.reuseIdentifier, for: indexPath) as! WalletTransferSummaryCell
            cell.amount = self.balance
            return cell
        case .confirm:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletTransferConfirmCell.reuseIdentifier, for: indexPath) as! WalletTransferConfirmCell
            cell.delegate = self
            return cell
        }
    }
}

extension WalletTransferController : WalletTransferConfirmCellDelegate {
    func didTapContinue() {
        if (self.transferAmount ?? 0) > Double(self.availableAmount ?? "0") ?? 0 {
             
        } else if self.transferBankName == "" {

        } else if self.IBANNumber == "" {

        } else {
            self.WSForTransferAmount()
        }
    }
}

extension WalletTransferController : WalletTransferAmountCellDelegate {
    func didChangeAmount(amount: Double) {
        self.transferAmount = amount
        self.balance = "\(amount)"
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 3)], with: .fade)
        print("amount")
    }
}

extension WalletTransferController : WalletTransferBankTransferCellDelegate {
    func didChangeBankName(name: String) {
        self.transferBankName = name
    }
    
}

extension WalletTransferController : WalletTransferIBANCellDelegate {
    func didChangeIBAN(iban: String) {
        self.IBANNumber = iban
    }
}






