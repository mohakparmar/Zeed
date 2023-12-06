//
//  ProfileSellerView.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit
import Parchment
import JGProgressHUD

enum ProfileSellerItems: Int, CaseIterable {
    case productOrders
    case auctions
    case liveAuctions
    case earnings
    case myProducts
    case actionButtons
    case editProfile

    var description: String {
        switch self {
        case .productOrders:
            return appDele!.isForArabic ? Product_Orders_ar : Product_Orders_en
        case .auctions:
            return appDele!.isForArabic ? Auctions_ar : Auctions_en
        case .liveAuctions:
            return appDele!.isForArabic ? Live_Auction_ar : Live_Auction_en
        case .earnings:
            return appDele!.isForArabic ? Earnings_ar : Earnings_en
        case .myProducts:
            return appDele!.isForArabic ? My_Products_ar : My_Products_en
        case .actionButtons:
            return ""
        case .editProfile:
            return ""
        }
    }
}

class ProfileSellerViewController: UIViewController {
    //MARK: - Properties
    var tableView: UITableView
    
    //MARK: - Lifecycle
    init() {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
        
        title = appDele!.isForArabic ? Sellers_ar : Sellers_en

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ProfileSellerProductOrdersCell.self, forCellReuseIdentifier: ProfileSellerProductOrdersCell.reuseIdentifier)
        tableView.register(ProfileSellerAuctionsCell.self, forCellReuseIdentifier: ProfileSellerAuctionsCell.reuseIdentifier)
        tableView.register(ProfileSellerLiveAuctionsCell.self, forCellReuseIdentifier: ProfileSellerLiveAuctionsCell.reuseIdentifier)
        tableView.register(ProfileSellerEarningCell.self, forCellReuseIdentifier: ProfileSellerEarningCell.reuseIdentifier)
        tableView.register(ProfileSellerMyProductsCell.self, forCellReuseIdentifier: ProfileSellerMyProductsCell.reuseIdentifier)
        tableView.register(ProfileSellerActionButtonCell.self, forCellReuseIdentifier: ProfileSellerActionButtonCell.reuseIdentifier)
        
        let footerView = UIView()
        footerView.setDimensions(height: 10, width: view.frame.width)
        
        tableView.tableFooterView = footerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Profile_Seller", str_nib_name: self.nibName ?? "")

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllData()
    }
    
    //MARK: - Selectors
    
    var objSta : SellerStatastics?
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        tableView.backgroundColor = .appBackgroundColor
        
        view.addSubview(tableView)
        tableView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    var hud = JGProgressHUD(style: .dark)
    
    //MARK: - API
    func fetchAllData() {
        hud.show(in: self.view, animated: true)
        Service.shared.getALlSellerTransaction { (allPosts, status, message) in
            if status {
                guard let allPosts = allPosts else { return }
                self.objSta = allPosts
                self.tableView.reloadData()
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: message)
            }
            self.hud.dismiss(animated: true)
        }
    }
}


extension ProfileSellerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileSellerItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = ProfileSellerItems(rawValue: indexPath.section)!
        
        switch type {
        case .productOrders:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSellerProductOrdersCell.reuseIdentifier, for: indexPath) as! ProfileSellerProductOrdersCell
            cell.obj = objSta
            cell.selectionStyle = .none
            return cell
        case .auctions:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSellerAuctionsCell.reuseIdentifier, for: indexPath) as! ProfileSellerAuctionsCell
            cell.obj = objSta
            cell.selectionStyle = .none
            return cell
        case .liveAuctions:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSellerLiveAuctionsCell.reuseIdentifier, for: indexPath) as! ProfileSellerLiveAuctionsCell
            cell.obj = objSta
            cell.selectionStyle = .none
            return cell
        case .earnings:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSellerEarningCell.reuseIdentifier, for: indexPath) as! ProfileSellerEarningCell
            cell.selectionStyle = .none
            cell.obj = objSta
            return cell
        case .myProducts:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSellerMyProductsCell.reuseIdentifier, for: indexPath) as! ProfileSellerMyProductsCell
            cell.selectionStyle = .none
            cell.obj = objSta
            return cell
        case .actionButtons:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSellerActionButtonCell.reuseIdentifier, for: indexPath) as! ProfileSellerActionButtonCell
            cell.isForEditProfile = false
            cell.configureUI()
            cell.selectionStyle = .none
            return cell
        case .editProfile:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSellerActionButtonCell.reuseIdentifier, for: indexPath) as! ProfileSellerActionButtonCell
            cell.isForEditProfile = true
            cell.configureUI()
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension ProfileSellerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = ProfileSellerItems(rawValue: indexPath.section)!
        
        if type == .actionButtons || type == .editProfile{
            return 50
        }
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let type = ProfileSellerItems(rawValue: section)!
        
        let customView = UIView()
        customView.backgroundColor = .appBackgroundColor
        customView.alpha = 0.7
        
        let titleLabel = UILabel()
        titleLabel.text = type.description
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .darkGray
        
        customView.addSubview(titleLabel)
        titleLabel.anchor(left: customView.leftAnchor, paddingLeft: 12)
        titleLabel.centerY(inView: customView)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: customView)
        }

        
        return customView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let type = ProfileSellerItems(rawValue: section)!
        if type == .actionButtons || type == .editProfile{
            return 20
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = ProfileSellerItems(rawValue: indexPath.section)!
        if type == .myProducts {
            let obj = MyProductListingViewController()
            self.navigationController?.pushViewController(obj, animated: true)
        } else if type == .editProfile {
            let controller = UINavigationController(rootViewController: EditMyProfileController1())
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        } else if type == .actionButtons {
            Service.shared.requestSalesReport(completion: { status, message in
                if status {
                    Utility.showISMessage(str_title: "Report sent successfully.", Message: "", msgtype: .success)
                } else {
                    Utility.showISMessage(str_title: message ?? "", Message: "", msgtype: .warning)
                }
            })
        }
    }
}


