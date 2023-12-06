//
//  AppDelegate.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseMessaging
import FirebaseCore
import GoogleMaps
import Adjust
import MFSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all

    var isForSearch : Bool = false
    var fcm_Token : String = ""
    
    var isForArabic : Bool = true
    
    var isFollowApiCalls : Bool = false
    
    var arrForCart: [CartItem] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        if let value = UserDefaults.standard.value(forKey: "lang") as? String {
            isForArabic = value == "1" ? false : true
        }
        registerForPushNotifications()
        
        MFSettings.shared.configure(token: "vVAgr13jyHXptLys83B8JY3sL15NLebLqjH8FoMr_N-nSHm2i2Dk6NcmkbkTWTtvgz-d6GdEeCZKWS2jwvI8n5xHTxtDZUR6rUrjEeFQ-MgHjG_aAXaev9ieu0qSHoxTnhmlUYyl9ukSTG7D7Hup_IKcNcP_f8Q9wLkzeYn3Ub5wJrISByF-ILnP9GjPaWzMV4TA82FEsRAke58uIJNFro-mt4v79ztnC9ey3ZKO1ZsKzlYgtUIobHwZqFAoocSsni_GJL6X5AoCtU5P7eu2-q5-bLW9p7ZIlDIctuTFkBSw8C7-JTU8mbETfmWk2b34joqQFRXCsm6tpgdR4ygk7POyQb7ej9layc6sGMN3Lw6EL7Rf4uXvcDoApAcpHRu9-AHh9_bP1Gn7hN-sGr0rRqHAkvihF53_Ony6w-p2Kmul14TI-gNBDqZzGSB2PbgmU3vnnqW0UQQS-etwogg95zBxg5QpTqMoHOw10cVzxOom4o2PmweDILlt3iKh3To9GF3ugqMZr1oDW45jtRGbZQVF6KX94ElitLKxaxdQ-ZOrv64VhDS4nIQg6yK9W7WCxUa4oChLPwrj4ntTjL3R24qmJfklRjgINrsE3mQuSFGhoZ7fWj4kqtUPtypbO97IrCjd0qpdLWPPozVOxVQzrpxnElj0z2guvTOqWh2SVLAhYLYYptiHxx0zQKy47ffHf8QMyg", country: .kuwait, environment: .live)

//        if #available(iOS 15, *) {
//            let appearance = UINavigationBarAppearance()
//            let navigationBar = UINavigationBar()
//            appearance.configureWithOpaqueBackground()
//            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appPrimaryColor]
//            appearance.backgroundColor = .appBackgroundColor
//            navigationBar.standardAppearance = appearance;
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        }
        
        Messaging.messaging().delegate = self
        
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        GMSServices.provideAPIKey("AIzaSyAHsiGx5UA7V5pdHLTsxCDSM2nGIo7blYw")
        
        if AppUser.shared.getDefaultUser() != nil {
            SocketService.shared.connectSocket()
        }
        
        
        window?.makeKeyAndVisible()
        window?.rootViewController = TabBarController()
        
        
        let yourAppToken = "8hclbm11nh4w"
        let environment = ADJEnvironmentProduction
        
        let adjustConfig = ADJConfig(
            appToken: yourAppToken,
            environment: environment)
        adjustConfig?.delegate = self
        Adjust.appDidLaunch(adjustConfig)

            
        if let objData = UserDefaults.standard.value(forKey: "appInstall") as? String {
            
        } else {
            let obj = ADJEvent.init(eventToken: "2zdfuv")
            Adjust.trackEvent(obj)
            UserDefaults.standard.setValue("appInstall", forKey: "appInstall")
        }
        
        
        let obj = ADJEvent.init(eventToken: "sgjrmp")
        Adjust.trackEvent(obj)

        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            return
        }
        print("Firebase registration token: \(fcmToken)")
        fcm_Token = fcmToken
        // fcm_Token = fcmToken
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        print("Token method called")
    }
    
    
    func loginAlert(con : UIViewController) {
        let alert = UIAlertController(title: "Login Require", message: "Please login to continue.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { alert in
            let objLogin = SignInController()
            objLogin.hidesBottomBarWhenPushed = true
            con.navigationController?.pushViewController(objLogin, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { alert in
            
        }))
        con.present(alert, animated: true)
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("DEBUG:- DID DISCONNECT")
        SocketService.shared.disconnectSocket()
    }


}

extension AppDelegate : AdjustDelegate {
    func adjustEventTrackingSucceeded(_ eventSuccessResponseData: ADJEventSuccess?) {

    }

}

//com.dm.Zeed

