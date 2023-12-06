//
//  MapviewViewController.swift
//  CrazyChiken
//
//  Created by hemant agarwal on 14/02/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

protocol MapViewDelegate {
    func getPlaceMark(placemark: CLPlacemark, latlng: CLLocationCoordinate2D)
    func getArea(areaName: String, latlng: CLLocationCoordinate2D)
}

class MapviewViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "Select_Location_Map", str_nib_name: self.nibName ?? "")

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
        
        self.title = appDele!.isForArabic ? Select_Your_Location_ar : Select_Your_Location_en
        btnSubmit.setTitle(appDele!.isForArabic ? Submit_ar : Submit_en, for: .normal)
        txtSearch.placeholder = appDele!.isForArabic ? Search_ar : Search_en
//        if langId == "2" {
//            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
//            lblTitle.text = t_Select_your_Location_ar
//            btnSubmit.setTitle(str: t_Submit_ar)
//            txtSearch.placeholder = t_Search_location_ar
//        }

        indicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtSearch.setRadius(radius: txtSearch.viewHeightBy2)
        btnSubmit.setRadius(radius: btnSubmit.viewHeightBy2)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if myLocation {
            myLocation = false
            indicator.isHidden = true
            indicator.stopAnimating()
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 17)
            map?.camera = camera
            map?.animate(to: camera)
        }
    }
    
    @IBAction func btnSubmitClick(_ sender: Any) {
        let locValue: CLLocationCoordinate2D = map.projection.coordinate(for: map.center)
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        self.getAddressFromLatlong(str: String(format: "%f,%f", locValue.latitude, locValue.longitude), location: locValue)
        location.geocode { placemark, error in
            if let error = error as? CLError {
                print("CLError:", error)
                return
            } else if let placemark = placemark?.first {
                // you should always update your UI in the main thread
                DispatchQueue.main.async {
                    //  update UI here
                    self.delegate?.getPlaceMark(placemark: placemark, latlng: locValue)
//                    print("name:", placemark.name ?? "")
//                    print("address1:", placemark.thoroughfare ?? "")
//                    print("address2:", placemark.subThoroughfare ?? "")
//                    print("neighborhood:", placemark.subLocality ?? "")
                    print("city:", placemark.locality ?? "")
                    print("state:", placemark.administrativeArea ?? "")
//                    print("subAdministrativeArea:", placemark.subAdministrativeArea ?? "")
//                    print("zip code:", placemark.postalCode ?? "")
//                    print("country:", placemark.country ?? "", terminator: "")
//                    print("isoCountryCode:", placemark.isoCountryCode ?? "")
//                    print("region identifier:", placemark.region?.identifier ?? "")
//                    print("timezone:", placemark.timeZone ?? "", terminator:"")
                }
            }
        }
    }
    
    // MARK: - ButtonClicks
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMyLocationClick(_ sender: Any) {
        myLocation = true
        indicator.isHidden = false
        indicator.startAnimating()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtSearch.text?.count ?? 0 > 0 {
            getAddressFromKeyWork(str: txtSearch.text!)
        }
        
        let nextTag = textField.tag + 1
        let nextResponder = self.view.viewWithTag(nextTag) as! UITextField?
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    func getAddressFromKeyWork(str:String) {
        WSManage.getDataWithURL(name: "https://api.opencagedata.com/geocode/v1/json?q=" + str + "&key=a288a79aeb4846569017491937639056&countrycode=KW") { (isFinished, dict) in
            if let obj = dict?["results"] as? [[String:AnyObject]] {
                if obj.count > 0 {
                    let objLocation = obj[0]
                    print(objLocation)
                    if let objGeo = objLocation["geometry"] as? [String:AnyObject] {
                        let objLat = Utility.getValue(dict: objGeo, key: "lat")
                        let objLng = Utility.getValue(dict: objGeo, key: "lng")
                        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(objLat.floatValue), longitude: CLLocationDegrees(objLng.floatValue), zoom: 17)
                        self.map?.camera = camera
                        self.map?.animate(to: camera)
                    }
                }
            }
        }
    }
    
    
    func getAddressFromLatlong(str:String, location : CLLocationCoordinate2D) {
        WSManage.getDataWithURL(name: "https://api.opencagedata.com/geocode/v1/json?q=" + str + "&key=a288a79aeb4846569017491937639056") { (isFinished, dict) in
            if let obj = dict?["results"] as? [[String:AnyObject]] {
                if obj.count > 0 {
                    let objLocation = obj[0]
                    print(objLocation)
                    if let objGeo = objLocation["components"] as? [String:AnyObject] {
                        if let obj = objGeo["suburb"] as? String {
                            self.delegate?.getArea(areaName: obj, latlng: location)
                        } else if let obj = objGeo["town"] as? String {
                            self.delegate?.getArea(areaName: obj, latlng: location)
                        } else if let obj = objGeo["city"] as? String {
                            self.delegate?.getArea(areaName: obj, latlng: location)
                        } else if let obj = objGeo["state"] as? String {
                            self.delegate?.getArea(areaName: obj, latlng: location)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    
    // MARK: - Variables and Other Declarations
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var map: GMSMapView!
    let locationManager = CLLocationManager()
    
    var myLocation:Bool = true
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnMyLocation: UIButton!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var delegate : MapViewDelegate? = nil
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
}
