//
//  MapLocationViewController.swift
//  SunsetSunrise
//
//  Created by Sebastian on /17/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapLocationViewController: UIViewController {
    
    @IBOutlet weak var googleMap: GMSMapView!
    var modelController: ModelController!
    var marker: GMSMarker!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    var mapModeSelector: UISegmentedControl = {
        let mms = UISegmentedControl(items: ["Map", "Satalite"])
        mms.translatesAutoresizingMaskIntoConstraints = false
        mms.selectedSegmentIndex = 0
        mms.tintColor = .black
        mms.addTarget(self, action: #selector(mapModeChange(_:)), for: .valueChanged)
        return mms
    }()
    var doneBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        btn.setTitle("Done", for: .normal)
        btn.addTarget(self, action: #selector(doneChoosing), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - View controller lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapSubs()
        setupSearch()
    }
    
    // MARK: - View setups
    
    func setupMapSubs() {
        googleMap.delegate = self
        googleMap.addSubview(mapModeSelector)
        googleMap.addSubview(doneBtn)
        
        mapModeSelector.centerXAnchor.constraint(equalTo: googleMap.centerXAnchor).isActive = true
        mapModeSelector.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        doneBtn.leftAnchor.constraint(equalTo: mapModeSelector.rightAnchor, constant: 50).isActive = true
        doneBtn.centerYAnchor.constraint(equalTo: mapModeSelector.centerYAnchor).isActive = true
    }
    
    func setupSearch() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        navigationItem.titleView = searchController?.searchBar
        definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    // MARK: - Actions
    
    @objc func mapModeChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            googleMap.mapType = .normal
        case 1:
            googleMap.mapType = .hybrid
        default:
            break
        }
    }
    
    @objc func doneChoosing() {
        if modelController.locationDate.coordinates.latitude != "" {
            let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpDatePicker") as! PopUpDatePickViewController
            self.addChild(popUp)
            popUp.view.frame = self.view.frame
            popUp.modelController = modelController
            self.view.addSubview(popUp.view)
        } else {
            alertPopUp(title: "Pick location", message: "You can pick location by holding on a place on map or search.")
        }
    }
    
}



extension MapLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let camera = GMSCameraPosition(target: position, zoom: 3)
        
        modelController.locationDate.adress = place.formattedAddress!
        modelController.locationDate.coordinates.latitude = "\(position.latitude)"
        modelController.locationDate.coordinates.longitude = "\(position.longitude)"
        
        googleMap.clear()
        marker = GMSMarker(position: position)
        marker.title = place.formattedAddress
        marker.map = googleMap
        googleMap.camera = camera
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension MapLocationViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        let geoCoder = GMSGeocoder()
        googleMap.clear()
        print(coordinate.latitude)
        print(coordinate.longitude)
        modelController.locationDate.coordinates.latitude = "\(coordinate.latitude)"
        modelController.locationDate.coordinates.longitude = "\(coordinate.longitude)"
        print(modelController.locationDate.coordinates.latitude)
        print(modelController.locationDate.coordinates.longitude)
        marker = GMSMarker(position: coordinate)
        geoCoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let adress = address.lines else {
                return
            }
            self.marker.title = adress.joined(separator: "\n")
            self.modelController.locationDate.adress = adress.joined(separator: "\n")
        }
        print(modelController.locationDate.coordinates.latitude)
        print(modelController.locationDate.coordinates.longitude)
        marker.map = mapView
    }
}
