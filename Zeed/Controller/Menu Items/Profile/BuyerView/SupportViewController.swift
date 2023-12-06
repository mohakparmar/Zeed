//
//  SupportViewController.swift
//  Zeed
//
//  Created by Mohak Parmar on 24/01/23.
//

import UIKit
import JGProgressHUD
import Network
import ZendeskSDKMessaging
import ZendeskSDK

enum SupportItem: Int, CaseIterable {
    case zenDeskChat
    case email
    case phone
 
    var description: String {
        switch self {
        case .zenDeskChat:
            return appDele!.isForArabic ? ZenDesk_ar : ZenDesk_en
        case .email:
            return appDele!.isForArabic ? Email_Us_ar : Email_Us_en
        case .phone:
            return appDele!.isForArabic ? Call_Us_ar : Call_Us_en
        }
    }
    
    var image: UIImage {
        switch self {
        case .zenDeskChat:
            return #imageLiteral(resourceName: "invoice").withRenderingMode(.alwaysOriginal)
        case .email:
            return #imageLiteral(resourceName: "private").withRenderingMode(.alwaysOriginal)
        case .phone:
            return #imageLiteral(resourceName: "private").withRenderingMode(.alwaysOriginal)
        }
    }
}

class SupportViewController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView
    var hud = JGProgressHUD(style: .dark)
    
    //MARK: - Lifecycle
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        title = appDele!.isForArabic ? Support_ar : Support_en
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Support", str_nib_name: self.nibName ?? "")

        configureUI()
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
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        collectionView.backgroundColor = .appBackgroundColor
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
    }
    
    @objc func closeZendeskChatNavController() {
        self.dismiss(animated: true)
    }
}


extension SupportViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SupportItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
        let type = SupportItem(rawValue: indexPath.row)!
        cell.supportCellType = type
        return cell
    }
}

extension SupportViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = SupportItem(rawValue: indexPath.row)!
        
        switch type {
        case .zenDeskChat:
            Zendesk.initialize(withChannelKey: "eyJzZXR0aW5nc191cmwiOiJodHRwczovL3plZWQ3MDgzLnplbmRlc2suY29tL21vYmlsZV9zZGtfYXBpL3NldHRpbmdzLzAxR1FGRlFBWjIxMDJCV1ZCV0NaWDVGSjZNLmpzb24ifQ==",
                               messagingFactory: DefaultMessagingFactory()) { result in
                if case let .failure(error) = result {
                    print("Messaging did not initialize.\nError: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        
                        
                        guard let viewController = Zendesk.instance?.messaging?.messagingViewController() else { return }
                        
                        let navController = UINavigationController()

                        navController.viewControllers = [viewController]

                        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action:  #selector(self.closeZendeskChatNavController))

                              DispatchQueue.main.async {
                                  self.present(navController, animated: true)
                              }
                    }
                }
            }

        break
        case .email:
            let email = "support@zeedco.co"
            if let url = URL(string: "mailto:\(email)") {
              if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
              } else {
                UIApplication.shared.openURL(url)
              }
            }
        case .phone:
            if let url = URL(string: "tel://\(96557552992)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
            break
        }
    }
}
