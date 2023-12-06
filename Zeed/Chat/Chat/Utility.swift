import UIKit
import ISMessages
import Photos
import SDWebImage
import Nuke
import AVKit
import JGProgressHUD
import Adjust
import IDMPhotoBrowser

let trnForm_En = (CGAffineTransform(scaleX: 1.0, y: 1.0))
let trnForm_Ar = (CGAffineTransform(scaleX: -1.0, y: 1.0))

let applicationMainColor = "007DA5"
let placeHolderColor = "FFFFFF"
let borderColor = "707070"

let Din_Regular = "D-DIN"
let Quicksand_Bold = "Quicksand-Bold"

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let appDele = (UIApplication.shared.delegate as? AppDelegate)


class Utility: NSObject {

    static private var hud = JGProgressHUD(style: .dark)
    
    class func openScreenView(str_screen_name: String, str_nib_name: String) {
        let obj = ADJEvent.init(eventToken: "4ivi3m")
        obj?.addCallbackParameter("screen_class", value: str_nib_name)
        obj?.addCallbackParameter("screen_name", value: str_screen_name)
        Adjust.trackEvent(obj)
    }

    class func getImagePreviewClass(str:String) -> IDMPhotoBrowser {
        let photo:IDMPhoto = IDMPhoto(url: URL(string: str))
        let browser:IDMPhotoBrowser = IDMPhotoBrowser(photos: [photo])
        browser.displayActionButton = false;
        browser.useWhiteBackgroundColor = true;
        browser.usePopAnimation = true;
        browser.displayArrowButton = true;
        browser.displayCounterLabel = true;
        browser.setInitialPageIndex(0)
        return browser
    }

    class func CheckOut(transaction_id: String, content_type:String, productPrice:String, item_id:String) {
        let obj = ADJEvent.init(eventToken: "al9w7f")
        if let currentUser = AppUser.shared.getDefaultUser() {
            obj?.addCallbackParameter("UserId", value: currentUser.id)
            obj?.addCallbackParameter("UserName", value: currentUser.userName)
            obj?.addCallbackParameter("Email", value: currentUser.email)
            obj?.addCallbackParameter("Mobile", value: currentUser.mobileNumber)
        }
        obj?.addCallbackParameter("transaction_id", value: transaction_id)
        obj?.addCallbackParameter("content_type", value: content_type)
        obj?.addCallbackParameter("item_id", value: item_id)
        obj?.addCallbackParameter("payment_type", value: "KNET")
        obj?.addCallbackParameter("currency", value: "KWD")
        obj?.addCallbackParameter("value", value: productPrice)
//        obj?.setRevenue(Double(productPrice) ?? 0, currency: "KWD")
        Adjust.trackEvent(obj)
    }


    class func Purchased(transaction_id: String, content_type:String, productPrice:String, item_id:String) {
        let obj = ADJEvent.init(eventToken: "7iops4")
        if let currentUser = AppUser.shared.getDefaultUser() {
            obj?.addCallbackParameter("UserId", value: currentUser.id)
            obj?.addCallbackParameter("UserName", value: currentUser.userName)
            obj?.addCallbackParameter("Email", value: currentUser.email)
            obj?.addCallbackParameter("Mobile", value: currentUser.mobileNumber)
        }
        obj?.addCallbackParameter("transaction_id", value: transaction_id)
        obj?.addCallbackParameter("content_type", value: content_type)
        obj?.addCallbackParameter("item_id", value: item_id)
        obj?.addCallbackParameter("payment_type", value: "KNET")
        obj?.addCallbackParameter("currency", value: "KWD")
        obj?.addCallbackParameter("value", value: productPrice)
//        obj?.setRevenue(Double(productPrice) ?? 0, currency: "KWD")
        Adjust.trackEvent(obj)
        
        let objRevenue = ADJEvent.init(eventToken: "z4nk9c")
        objRevenue?.addCallbackParameter("transaction_id", value: transaction_id)
        objRevenue?.addCallbackParameter("content_type", value: content_type)
        objRevenue?.addCallbackParameter("item_id", value: item_id)
        objRevenue?.addCallbackParameter("payment_type", value: "KNET")
        objRevenue?.addCallbackParameter("currency", value: "KWD")
        objRevenue?.addCallbackParameter("value", value: productPrice)
        objRevenue?.setRevenue(Double(productPrice) ?? 0, currency: "KWD")
        Adjust.trackEvent(objRevenue)
    }


    
    class func addToCartProduct(productId: String, productName:String, productPrice:Double, productVariantId:String, productVariantName:String) {
        let obj = ADJEvent.init(eventToken: "tztuxs")
        obj?.addCallbackParameter("productId", value: productId)
        obj?.addCallbackParameter("productName", value: productName)
        obj?.addCallbackParameter("productPrice", value: "\(productPrice)")
        obj?.addCallbackParameter("productVariantId", value: productVariantId)
        obj?.addCallbackParameter("productVariantName", value: productVariantName)
        if let currentUser = AppUser.shared.getDefaultUser() {
            obj?.addCallbackParameter("UserId", value: currentUser.id)
            obj?.addCallbackParameter("UserName", value: currentUser.userName)
            obj?.addCallbackParameter("Email", value: currentUser.email)
        }
//        obj?.setRevenue(Double(productPrice) ?? 0, currency: "KWD")
        Adjust.trackEvent(obj)
        
    }

    
    class func saveImage(image: UIImage) -> String {
        guard let data = image.pngData() ?? image.jpegData(compressionQuality: 0.8)  else {
            return ""
        }
        let path = self.getFileNameWithExt(strFileType: "png")
        let fileUrl = URL(fileURLWithPath: path)
        do {
            try data.write(to: fileUrl)
            return path
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    class func getFileNameWithExt(strFileType:String) -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        var Timestamp: String {
            return String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000)
        }
        let filePath="\(documentsPath)/" + strFileType + Timestamp  + "." + strFileType
        
        let fileExists = FileManager().fileExists(atPath: filePath)
        if fileExists {
            do {
                _ = try! FileManager().removeItem(atPath: filePath)
            } catch {
                print("Could not clear temp folder: \(error)")
            }
        }

        return filePath
    }


    typealias CompletionHandler = (_ success:Bool) -> Void
    class func convertVideoToLowQuailtyWithInputURL(input:URL, output:URL, handler: @escaping CompletionHandler) {
        let asset = AVURLAsset(url: input, options: nil)
        let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetLowQuality)
        session?.outputURL = output
        session?.outputFileType = AVFileType.mov
        session?.exportAsynchronously(completionHandler: {
            if session?.status == AVAssetExportSession.Status.completed {
                handler(true)
            } else {
                handler(false)
            }
        })
    }
    
    
    class func getVideoPreviewClass(str:String) -> AVPlayerViewController {
        let videoURL = URL(string: str)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        return playerViewController
    }
    
//    class func getImagePreviewClass(str:String) -> IDMPhotoBrowser {
//        let photo:IDMPhoto = IDMPhoto(url: URL(string: str))
//        let browser:IDMPhotoBrowser = IDMPhotoBrowser(photos: [photo])
//        browser.displayActionButton = false;
//        browser.useWhiteBackgroundColor = true;
//        browser.usePopAnimation = true;
//        browser.displayArrowButton = true;
//        browser.displayCounterLabel = true;
//        browser.setInitialPageIndex(0)
//        return browser
//    }
    
    class func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset640x480) else {
            handler(nil)
            
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }

    class func getThumbnailImageLocalURL(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    class func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
    
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
           // print(error)
        }
        return UIImage(named: "splashLogo")
    }

    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGRect{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
//        label.sizeToFit()
        return label.frame
    }
    
    class func getValue(dict:[String : AnyObject], key:String) -> String {
        var strId:String = ""
        if let result = dict[key]?.string {
            strId = result
        } else if dict[key] != nil {
            strId = "\(dict[key]!)"
        } else {
            strId =  ""
        }
        if strId == "<null>" {
            return ""
        }
        return strId
    }

    
    class func animateMenu(menuView:UIView) {
        let frame:CGRect;
        if 0 == menuView.viewXPos {
            frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        } else {
            menuView.isHidden = false
            frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            menuView.frame = frame
        }) { (finished:Bool) in
            if 0 != menuView.viewXPos {
                menuView.isHidden = true
            }
        }
    }

    class func getJsonFromArray(array:NSMutableArray) -> String {
        do {
            let jsonData2 = try JSONSerialization.data(withJSONObject: array, options: [])
            return String(data: jsonData2, encoding: .utf8)!
        } catch {
            return ""
        }
    }
    
    class func showISMessage(str_title:String, Message:String, msgtype: ISAlertType, duration: Int = 5, completion: (() -> Void)? = nil) {
        ISMessages.showCardAlert(withTitle: str_title, message: Message, duration: 5, hideOnSwipe: true, hideOnTap: true, alertType: msgtype, alertPosition: ISAlertPosition.top) { (finished:Bool) in
            completion?()
        }
    }
    
    class func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }


    
    func getJsonFromArray(dictionary:NSDictionary) -> String {
        do {
            let jsonData2 = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return String(data: jsonData2, encoding: .utf8)!
        } catch {
            return ""
        }
    }
    
    class func getStringFrom(deviceToken: Data) -> String {
        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        return token
    }
    
    class func getDateFromTimeStamp(str_time: String, str_format:String) -> String {
        let date1 = Date.init(timeIntervalSince1970: Double(str_time)!/1000)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let yourDate:Date = dateFormatterGet.date(from: dateFormatterGet.string(from: date1))!
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = str_format
        let str10 = dateFormatterPrint.string(from: yourDate)
        return str10;
    }

    
    class func getDateFromTimeStampWithout1000(str_time: String, str_format:String) -> String {
        let date1 = Date.init(timeIntervalSince1970: Double(str_time)!)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let yourDate:Date = dateFormatterGet.date(from: dateFormatterGet.string(from: date1))!
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = str_format
        let str10 = dateFormatterPrint.string(from: yourDate)
        return str10;
    }

    class func getDeviceId() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "";
    }
 
    class func checkNullString(strText: Any) -> String {
        let str:String = String(describing: strText)
        if str != "(null)" && str != "<null>" && type(of: str) == String.self {
            return str
        }
       return ""
    }
    
    class func SetImageTintColor(imgView: UIImageView, str_color:String) {
        let img: UIImage? = imgView.image?.withRenderingMode(.alwaysTemplate)
        imgView.image = img
        imgView.tintColor = UIColor.init().setColor(hex: str_color, alphaValue: 1.0)
    }
    
    
    class func showAlertWithTitleAndMessage(title:String, Msg:String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: Msg, preferredStyle:.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default)
        { action -> Void in
            // Put your code here
        })
        return alertController
    }
    
    static func showHud(view: UIView) {
        self.hud.show(in: view, animated: true)
    }
    
    static func hideHud() {
        self.hud.dismiss(animated: true)
    }
    

    class func resizeImageWithImage(image:UIImage, width:CGFloat, height:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage;
    }
    
    class func isConnectedToNetwork()->Bool{
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        var response: URLResponse?
        
        do {
            _ = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    Status = true
                }
            }
        } catch {
            
        }
        return Status
    }
    
    
    class func addBarButtonWithImage(str:String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.init(named: str), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }

    func addDoneButtonOnRight() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor().setColor(hex: "F8D960", alphaValue: 1.0)
        button.setTitleColor(UIColor().setColor(hex: "00113E", alphaValue: 1.0), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        return button
    }

    
    func addBarButtonWithText(text:String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.init(name: Din_Regular, size: 15)
        button.setTitleColor(UIColor().setColor(hex: "0654A8", alphaValue: 1.0), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        return button
    }
    
    
    func addBackButtonItem() -> UIButton {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage.init(named: "back"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }

    
    class func isConnectedToNetwork(url:String) {
        if let url = URL(string: url) {
            if #available(iOS 10, *){
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func addButtonGradient(btn:UIButton, color1:String, color2:String) {
        let l = CAGradientLayer()
        l.frame = btn.bounds
        l.colors = [UIColor().setColor(hex: color1, alphaValue: 1.0).cgColor, UIColor().setColor(hex: color2, alphaValue: 1.0).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 16
        btn.layer.insertSublayer(l, at: 0)
    }
    
}

extension PHAsset {
    func getPathOfAssert() -> String {
        var url:URL?
        self.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (input, _) in
            url = input?.fullSizeImageURL
        }
        return url?.absoluteString ?? ""
    }
}

extension String
{
    
    
    func utf8EncodedString() -> String {
         let messageData = self.data(using: .nonLossyASCII)
         let text = String(data: messageData!, encoding: .utf8)
        return text!
    }

    func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
        guard let range = self.range(of: needle) else { return nil }
        if beforeNeedle {
            return self.substring(to: range.lowerBound)
        }
        return self.substring(from: range.upperBound)
    }

    var floatValue: Float {
        return (self as NSString).floatValue
    }

    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }

    var intValue: Int {
        return (self as NSString).integerValue
    }

    
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func decode() -> String? {
        
        if self.contains("\\u") {
            let data = self.data(using: .utf8)!
            return String(data: data, encoding: .nonLossyASCII)
        } else {
            let decodedString = self.removingPercentEncoding
            return decodedString
        }
    }

    
    func checkEmpty() -> Bool {
        if self.getTrimmedtext() == "" {
            return true
        } else {
            return false
        }
    }

    func equalIgnoreCase(_ compare:String) -> Bool {
        return self.uppercased() == compare.uppercased()
    }
    
    func getTrimmedtext() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    func getAttributedStringWithNsString(text:String) -> NSMutableAttributedString {
        let htmlData = NSString(string: text).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                              options: options,
                                                              documentAttributes: nil)
        return attributedString ?? NSMutableAttributedString();
    }

    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func getURLFromString( str:String) -> URL? {
        if let url = URL(string: str) {
            return url
        } else {
            return nil
        }
    }
    
    func getEncodeString( str:String) -> String {
        return str.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? ""
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func substringRange(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        let range = startIndex..<endIndex
        return String(self[range])
    }
    
    var wordCount: Int {
        let regex = try? NSRegularExpression(pattern: "\\w+")
        return regex?.numberOfMatches(in: self, range: NSRange(location: 0, length: self.utf16.count)) ?? 0
    }
    
    func replacingOccurrences(of search: String, with replacement: String, count maxReplacements: Int) -> String {
        var count = 0
        var returnValue = self
        while let range = returnValue.range(of: search) {
            returnValue = returnValue.replacingCharacters(in: range, with: replacement)
            count += 1
            // exit as soon as we've made all replacements
            if count == maxReplacements {
                return returnValue
            }
        }
        return returnValue
    }
    
    func truncate(to length: Int, addEllipsis: Bool = false) -> String  {
        if length > count { return self }
        
        let endPosition = self.index(self.startIndex, offsetBy: length)
        let trimmed = self[..<endPosition]
        
        if addEllipsis {
            return "\(trimmed)..."
        } else {
            return String(trimmed)
        }
    }
    
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        return "\(prefix)\(self)"
    }
    
}


extension UIImage {
    
    typealias CompletionHandler = (UIImage,Bool) -> Void

    func compressImage(completionHandler: CompletionHandler) {
        let oldImage = self

        let actualHeight:CGFloat = oldImage.size.height
        let actualWidth:CGFloat = oldImage.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 450
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.4

        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        oldImage.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = img.jpegData(compressionQuality: compressionQuality)!
        UIGraphicsEndImageContext()
        let image = UIImage(data: imageData)
        print("***** Compressed ʼSize \(imageData.description) **** ")

        completionHandler(image!, true)

//        var imageData =  Data(oldImage.pngData()! )
//        print("***** Uncompressed Size \(imageData.description) **** ")
//        imageData = oldImage.jpegData(compressionQuality: 2)!
//        print("***** Compressed Size \(imageData.description) **** ")
//        let image = UIImage(data: imageData)
//        completionHandler(image!, true)
    }
    
    func rotated(byDegrees degree: Double) -> UIImage {
        let radians = CGFloat(degree * .pi) / 180.0 as CGFloat
        let rotatedSize = self.size
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        let bitmap = UIGraphicsGetCurrentContext()
        bitmap?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap?.rotate(by: radians)
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(
            self.cgImage!,
            in: CGRect.init(x: -self.size.width / 2, y: -self.size.height / 2 , width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() // this is needed
        return newImage!
    }

    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result ?? UIImage()
        })
        return thumbnail
    }
    
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
    func getPlaceHolderImage() -> UIImage {
        return UIImage(named: "placeHolder") ?? UIImage()
    }

}

extension UIColor {

    static let appColor = UIColor.appPrimaryColor
    static let appColorLight = UIColor.appPrimaryColor.withAlphaComponent(0.5)
    static let selectedColor = UIColor().setColor(hex: "009192", alphaValue: 1.0)
    static let deselectedColor = UIColor().setColor(hex: "C1C1C1", alphaValue: 1.0)
    static let unselect = UIColor().setColor(hex: "707070", alphaValue: 1.0)

    
    
    
    func setColor (hex:String, alphaValue:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alphaValue)
        )
    }
}

extension UITextField {
    
    func settextPaddingAndBorder() {
        self.textLeftPadding(x: 0, y: 0, width: 10, height: 10)
        self.setBorder(colour: applicationMainColor, alpha: 1.0, radius: self.viewHeightBy2, borderWidth: 1.0)
    }
    
    func setTextFieldBottomBorder(color:String) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 0.5)
        bottomBorder.backgroundColor = UIColor.init().setColor(hex: color, alphaValue: 1.0).cgColor
        self.layer .addSublayer(bottomBorder)
    }
    
    func textLeftPadding(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) {
        let paddingView = UIView.init(frame: CGRect(x: x, y: y, width: width, height: height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func settextFieldBorder(colour:String, alpha:CGFloat, radius:CGFloat, borderWidth:CGFloat ) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor =  UIColor.init().setColor(hex: colour, alphaValue: alpha).cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func setTextFieldPlaceHolderColour(colour:String, alpha:CGFloat ) {
        let iVar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")!
        let placeholderLabel = object_getIvar(self, iVar) as! UILabel
        placeholderLabel.textColor = UIColor().setColor(hex: colour, alphaValue: alpha)
    }
}

extension UIButton {
    
    private func actionHandleBlock(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    
    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }
    
    func actionHandle(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
        self.actionHandleBlock(action: action)
        self.addTarget(self, action: #selector(UIButton.triggerActionHandleBlock), for: control)
    }
    
    func setSelected(sender:UIButton) {
        self.setTitleColor(.appColor, for: .normal)
        sender.setTitleColor(UIColor().setColor(hex: "FFFFFF", alphaValue: 0.3), for: .normal)
    }
    
    func isSelectedButton() -> Bool {
        if self.titleLabel?.textColor == UIColor.appColor {
            return true
        } else {
            return false
        }
    }
    
    func addGradientAndCorner() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
        Utility.addButtonGradient(btn: self, color1: "3B6AB4", color2: "6F9DD7")
    }
    
    func setbuttonBdr(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setButtomdBottomBorder(color:String) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 0.5)
        bottomBorder.backgroundColor = UIColor.init().setColor(hex: color, alphaValue: 1.0).cgColor
        self.layer .addSublayer(bottomBorder)
    }
    
    func setButton(text:String, fontName:String, fontSize:CGFloat, textColor:String, backGroundColor:String)  {
        self.titleLabel?.font = UIFont(name: fontName, size: fontSize)
        self.setTitle(text, for: .normal)
        self.titleLabel?.textColor = UIColor.init().setColor(hex: textColor, alphaValue: 1.0)
        self.backgroundColor = UIColor.init().setColor(hex: backGroundColor, alphaValue: 1.0)
    }
    
    func setButtonShadow(offsetX: CGFloat, offsetY: CGFloat, color: String, opacity: Float, radius: CGFloat, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowColor = UIColor.init().setColor(hex: color, alphaValue: CGFloat(opacity)).cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


extension UIView {
    
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
    func animateTheHeartViewView() {
        
        self.isHidden = false
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.self.transform = .identity
            }, completion: {
                 (value: Bool) in
                self.isHidden = true
        })
    }

    
    func animateTheView() {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.self.transform = .identity
            },completion: nil)
    }

    func setRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func setBorder(colour:String, alpha:CGFloat, radius:CGFloat, borderWidth:CGFloat ) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.borderColor =  UIColor.init().setColor(hex: colour, alphaValue: alpha).cgColor
        layer.borderWidth = borderWidth
    }
    
    func setShadow() {
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds = false;
        self.clipsToBounds = true;
        self.layer.shadowRadius = 1
        self.layer.shadowColor = UIColor.init().setColor(hex: "242424", alphaValue: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
    }

    func setShadow(frame:CGRect, radius:CGFloat) {
        self.setBorder(colour: "", alpha: 0, radius: radius, borderWidth: 0)
        let shadowPath = UIBezierPath(rect: frame)
        self.layer.masksToBounds = false;
        self.layer.shadowRadius = 2
        self.layer.shouldRasterize = true
        self.layer.shadowColor = UIColor.init().setColor(hex: "000000", alphaValue: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    func addShadow(color:String = "242424", alpha:CGFloat = 0.3, shadowRadius:CGFloat = 2.0, radius: CGFloat) {
        self.setBorder(colour: "", alpha: 0, radius: radius, borderWidth: 0)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor().setColor(hex: color, alphaValue: alpha).cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0
    }

    
    func setViewShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func setXPosition(xValue:CGFloat) {
        self.frame = CGRect(x: xValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
    }

    func setYPosition(yValue:CGFloat) -> CGFloat {
        self.frame = CGRect(x: self.frame.origin.x, y: yValue, width: self.frame.size.width, height: self.frame.size.height)
        return yValue + self.frame.size.height 
    }

    func setHeightPosition(heightValue:CGFloat) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: heightValue)
    }

    func setWidthPosition(widthValue:CGFloat) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: widthValue, height: self.frame.size.height)
    }
    
    var viewWidth:CGFloat {
        return self.frame.size.width
    }

    var viewWidthBy2:CGFloat {
        return self.frame.size.width / 2
    }

    var viewHeight:CGFloat {
        return self.frame.size.height
    }

    var viewHeightBy2:CGFloat {
        return self.frame.size.height / 2
    }

    var viewXPos:CGFloat {
        return self.frame.origin.x
    }
    
    var viewYPos:CGFloat {
        return self.frame.origin.y
    }
}


extension UITextView {
    
    func setPlaceholder(text:String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.text.isEmpty
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    func updateTextFont() {
        if (self.text.isEmpty || self.bounds.size.equalTo(CGSize.zero)) {
            return;
        }
    
        let textViewSize = self.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
    
    
        var expectFont = self.font
        if (expectSize.height > textViewSize.height) {
    
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = self.font!.withSize(self.font!.pointSize - 1)
                self.font = expectFont
            }
        }
        else {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = self.font
                self.font = self.font!.withSize(self.font!.pointSize + 1)
            }
            self.font = expectFont
        }
    }
}


extension UIImageView {
    
    
    func setImageUsingUrl(_ imageUrl: String?){
        
        if imageUrl?.checkEmpty() == false {
            let options = ImageLoadingOptions(
               // placeholder: UIImage(named: "placeholder"),
                transition: .fadeIn(duration: 0.33)
            )
            Nuke.loadImage(with: URL(string: imageUrl ?? "")!, options: options, into: self)
        } else {
            
        }
        
        
//        let pipeline = ImagePipeline {
//            $0.isProgressiveDecodingEnabled = true
//        }
//        if imageUrl?.checkEmpty() == false {
//            let task = ImagePipeline.shared.loadImage(
//                with: URL(string: imageUrl!)!,
//                progress: { response, _, _ in
//                    if let response = response {
//                        self.image = response.image
//                    }
//                },
//                completion: { result in
//                    do {
//                        self.image = try? result.get().image
//                    } catch _ {
//
//                    }
//
//                    // Display the final image
//                }
//            )
//        }


      //  self.sd_setImage(with: URL(string: imageUrl!), placeholderImage:UIImage.init(named: "placeHolder"))
    }

    func setUserImageUsingUrl(_ imageUrl: String?){
        
        if imageUrl?.checkEmpty() == false {
            let options = ImageLoadingOptions(
                placeholder: UIImage(named: "userPlaceHolder"),
                transition: .fadeIn(duration: 0.33)
            )
            Nuke.loadImage(with: URL(string: imageUrl ?? "")!, options: options, into: self)
            self.contentMode = .scaleAspectFill
        } else {
            self.image = UIImage(named: "userPlaceHolder")
        }
    }

    func setImageUsingUrl(minUrl:String?, maxUrl: String?){
        self.sd_setImage(with: URL(string: minUrl!), placeholderImage: UIImage.init(named: "placeHolder"), options: SDWebImageOptions.cacheMemoryOnly) { (img, error, SDImageCacheType, url) in
            self.image = img
            self.sd_setImage(with: URL(string: maxUrl!), placeholderImage:UIImage.init(named: "placeHolder"))
        }
    }

    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            @unknown default:
                fatalError()
            }
            self.image = image
        }
    }
}


extension UILabel {
    func setLabel(text:String, fontName:String, fontSize:CGFloat, fontColor:String)  {
        self.text = text
        self.font = UIFont(name: fontName, size: fontSize)
        self.textColor = UIColor.init().setColor(hex: fontColor, alphaValue: 1.0)
    }
    
    func getSize(constrainedWidth: CGFloat) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: constrainedWidth, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension Date {
    func days(between otherDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfSelf = calendar.startOfDay(for: self)
        let startOfOther = calendar.startOfDay(for: otherDate)
        let components = calendar.dateComponents([.day], from: startOfSelf, to: startOfOther)
        return abs(components.day ?? 0)
    }
    
    func getElapsedInterval(to end: Date = Date()) -> String {
        
        if let interval = Calendar.current.dateComponents([Calendar.Component.year], from: self, to: end).day {
            if interval > 0 {
                return "\(interval) year\(interval == 1 ? "":"s")"
            }
        }
        
        if let interval = Calendar.current.dateComponents([Calendar.Component.month], from: self, to: end).month {
            if interval > 0 {
                return "\(interval) month\(interval == 1 ? "":"s")"
            }
        }
        
        if let interval = Calendar.current.dateComponents([Calendar.Component.weekOfMonth], from: self, to: end).weekOfMonth {
            if interval > 0 {
                return "\(interval) week\(interval == 1 ? "":"s")"
            }
        }
        
        if let interval = Calendar.current.dateComponents([Calendar.Component.day], from: self, to: end).day {
            if interval > 0 {
                return "\(interval) day\(interval == 1 ? "":"s")"
            }
        }
        
        if let interval = Calendar.current.dateComponents([Calendar.Component.hour], from: self, to: end).hour {
            if interval > 0 {
                return "\(interval) hour\(interval == 1 ? "":"s")"
            }
        }
        
        if let interval = Calendar.current.dateComponents([Calendar.Component.minute], from: self, to: end).minute {
            if interval > 0 {
                return "\(interval) minute\(interval == 1 ? "":"s")"
            }
        }
        
        return "Just now."
    }
    
    func calculateAgeOfUser() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        let age = ageComponents.year
        return age ?? 0;
    }
    
    func getFormattedDate(string: String , formatter:String) -> String{
        if string == "" {
            return ""
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        
        let date: Date? = NSDate(timeIntervalSince1970: Double(string)!) as Date
        
        return (date?.getElapsedInterval())!
//        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
     //   return dateFormatterPrint.string(from: date ?? Date());
    }

    
    func getTotalTime(string: String , formatter:String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        
     //   let date2: Date? = dateFormatterGet.date(from: string)
        let date2: Date? = NSDate(timeIntervalSince1970: Double(string)!) as Date

        return (date2?.getElapsedInterval())!

        let date1 = Date()

        let diff = Int(date1.timeIntervalSince1970  - date2!.timeIntervalSince1970 )

        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60

        print(hours)
        print(minutes)
        if hours > 0 {
            return String(format: "%dh:%dm", hours, minutes)
        } else {
            return String(format: "%dm", minutes)
        }
    }
}

let reuseIdentifier1: String = "cell"

extension UITableView {
    
    func registerNib(nibName:String, reUse:String = reuseIdentifier1) {
        self.register(UINib.init(nibName: nibName, bundle: nil), forCellReuseIdentifier: reUse)
    }
    
}
extension UICollectionView {
    
    func registerNib(nibName:String, reUse:String = reuseIdentifier1) {
        self.register(UINib.init(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: reUse)
    }
    
}


extension UIFont {
    static func availableFonts() {
        // Get all fonts families
        for family in UIFont.familyNames {
            NSLog("\(family)")
            // Show all fonts for any given family
            for name in UIFont.fontNames(forFamilyName: family) {
                NSLog("   \(name)")
            }
        }
    }
} 


extension URL {
    func verboseFileSizeInMB() {
        let p = self.path
        
        let attr = try? FileManager.default.attributesOfItem(atPath: p)
        
        if let attr = attr {
            let fileSize = Float(attr[FileAttributeKey.size] as! UInt64) / (1024.0 * 1024.0)
            
            print(String(format: "FILE SIZE: %.2f MB", fileSize))
        } else {
            print("No file")
        }
    }
}

extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}

extension CLPlacemark {

    var customAddress: String {
        get {
            return [[thoroughfare, subThoroughfare], [postalCode, locality]]
                .map { (subComponents) -> String in
                    // Combine subcomponents with spaces (e.g. 1030 + City),
                    subComponents.compactMap({ $0 }).joined(separator: " ")
                }
                .filter({ return !$0.isEmpty }) // e.g. no street available
                .joined(separator: ", ") // e.g. "MyStreet 1" + ", " + "1030 City"
        }
    }
}


extension AVAsset{
    func videoSize()->CGSize{
        let tracks = self.tracks(withMediaType: AVMediaType.video)
        if (tracks.count > 0){
            let videoTrack = tracks[0]
            let size = videoTrack.naturalSize
            let txf = videoTrack.preferredTransform
            let realVidSize = size.applying(txf)
            print(videoTrack)
            print(txf)
            print(size)
            print(realVidSize)
            return realVidSize
        }
        return CGSize(width: 0, height: 0)
    }
    
    var screenSize: CGSize? {
        if let track = tracks(withMediaType: .video).first {
            let size = __CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform)
            return CGSize(width: abs(size.width), height: abs(size.height))
        }
        return nil
    }


}

extension AVPlayer {
    func addProgressObserver(action:@escaping ((Double) -> Void)) -> Any {
        return self.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            if let duration = self.currentItem?.duration {
                let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
                let progress = (time/duration)
                action(progress)
            }
        })
    }
}

extension UIImage {
    class func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
   }
}

