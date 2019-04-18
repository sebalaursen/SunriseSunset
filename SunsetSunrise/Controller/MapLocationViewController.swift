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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapSubs()
        setupSearch()
    }
    
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
        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpDatePicker") as! PopUpDatePickViewController
        self.addChild(popUp)
        popUp.view.frame = self.view.frame
        self.view.addSubview(popUp.view)
        
    }
    
}

extension MapLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let camera = GMSCameraPosition(target: position, zoom: 3)
        googleMap.clear()
        marker = GMSMarker(position: position)
        marker.title = place.name
        marker.map = googleMap
        googleMap.camera = camera
        //navigationItem.titleView = nil
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
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
        let geocoder = GMSGeocoder()
        googleMap.clear()
        marker = GMSMarker(position: coordinate)
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let adress = address.lines else {
                return
            }
            self.marker.title = adress.joined(separator: "\n")
        }
        marker.map = mapView
    }
}
