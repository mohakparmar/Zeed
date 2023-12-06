//
//  SelectLocationController.swift
//  Zeed
//
//  Created by Shrey Gupta on 17/09/21.
//

import UIKit
import MapKit

private let reuseIdentifier = "cell"

struct SellingLocation {
    let title: String
    let coordinate: CLLocationCoordinate2D
}

protocol SelectLocationControllerDelegate: AnyObject {
    func updateLocation(location: SellingLocation)
}

class SelectLocationController: UIViewController, CLLocationManagerDelegate {
    //    MARK: - Properties
    var tableView = UITableView()
    
    weak var delegate: SelectLocationControllerDelegate?
    
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    private var searchResults = [MKLocalSearchCompletion]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var selectedLocation: SellingLocation? {
        didSet {
            guard selectedLocation != nil else { return }
            confirmButton.isEnabled = true
        }
    }
    
    //MARK: - UI Elements
    
    private let searchBar: UISearchBar = {
        return UISearchBar()
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(pop))
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CONFIRM", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appPrimaryColor
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSelectedLocation), for: .touchUpInside)
        return button
    }()
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.isEnabled = false
        Utility.openScreenView(str_screen_name: "Select_Location", str_nib_name: self.nibName ?? "")

        view.backgroundColor = .white
        enableLocationServices()
        configureMapView()
        
        configureSearchBar()
        configureTableView()
        setupToHideKeyboardOnTapOnView()

        view.addSubview(confirmButton)
        confirmButton.setDimensions(height: 50, width: view.frame.width - 50)
        confirmButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 15)
        confirmButton.centerX(inView: view)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        mapView.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        }
    }

    
    //    MARK: - Selectors
    
    @objc func handleSelectedLocation() {
        guard let location = selectedLocation else { return }
        delegate?.updateLocation(location: location)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc override func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    //    MARK: - Helper Functions
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        
        tableView.tableFooterView = UIView()
        
        let height = view.frame.height
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        
        view.addSubview(tableView)
    }
    
    func configureSearchBar(){
//        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = self.cancelButton
    }
    
    func configureSearchCompleter() {
//        let location = CLLocationManager().location
//        let region = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
//        searchCompleter.region = region
//        searchCompleter.delegate = self
    }
    
    func configureMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func enableLocationServices(){
        locationManager?.delegate = self
        
        
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: not determined")
            locationManager!.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            print("DEBUG: authorized always")
            configureSearchCompleter()
            locationManager!.startUpdatingLocation()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: authorized when in use")
            configureSearchCompleter()
            locationManager!.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    func geocodeAddressString(title: String, subTitle: String){
        let locationString = title + " " + subTitle
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            
            if let _ = error {
                Utility.showISMessage(str_title: "Error", Message: "Location not found, please select other location.", msgtype: .error)
                self.selectedLocation = nil
                return
            }
            
            guard let clPlacmark = placemarks?.first else { return }
            let placemark = MKPlacemark(placemark: clPlacmark)
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.dismissTable()
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            
            self.mapView.addAnnotationAndSelect(forCoordinates: annotation.coordinate)
            
            var annotations = self.mapView.annotations
            annotations.append(annotation)
            self.mapView.zoomToFit(annotations: annotations)
            
            let selectedLocation = SellingLocation(title: title, coordinate: annotation.coordinate)
            self.selectedLocation = selectedLocation
        }
    }
    
    func dismissTable() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame.origin.y = self.view.frame.height
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        configureSearchCompleter()
    }
}

//    MARK: - Delegate UISearchBarDelegate

extension SelectLocationController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.view.frame.origin.y
            }
        }
        
        if searchText == "" {
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.view.frame.height
            }
        }
        searchCompleter.queryFragment = searchText
    }
}

//    MARK: - Delegate TableView DataSource/Delegate

extension SelectLocationController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        let title = result.title
        let subTitle = result.subtitle
        
        print("DEBUG:- result: \(result)")
        
        geocodeAddressString(title: title, subTitle: subTitle)
    }
}

//    MARK: - Delegate SearchBarDelegate
extension SelectLocationController: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}

