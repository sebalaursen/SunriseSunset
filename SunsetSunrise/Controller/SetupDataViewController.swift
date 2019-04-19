//
//  SetupDataViewController.swift
//  SunsetSunrise
//
//  Created by Sebastian on /17/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import GooglePlaces

class SetupDataViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    var modelController: ModelController!
    var place: GMSPlace?

    let datePicker = UIDatePicker()
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setUpToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationTextField.text = modelController.locationDate.adress
        dateTextField.text = modelController.locationDate.date
        modelController.locationDate.timeDifference = 0
    }
    
    // MARK: - View setups
    
    func setupDatePicker() {
        datePicker.backgroundColor = .lightGray
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
    }
    
    
    func setUpToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = UIColor.darkGray
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dateTextField.inputAccessoryView = toolBar
    }
    
    // MARK: - Actions, segue prepare
    
    @objc func dismissPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        modelController.locationDate.date = formatter.string(from: datePicker.date)
        dateTextField.text = modelController.locationDate.date
        view.endEditing(true)
    }
    
    @IBAction func mapBtnAction(_ sender: Any) {
        performSegue(withIdentifier: "toMapSegue", sender: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if self.locationTextField.text != "" && self.dateTextField.text != "" {
            modelController.getTimeZone()
            let fetchSI = FetchSunInfo(url: RequestURL(latitude: Float(modelController.locationDate.coordinates.latitude)! , longitute: Float(modelController.locationDate.coordinates.longitude)! , date: modelController.locationDate.date))
            print(modelController.locationDate.date)
            fetchSI.fetch(completion: { (resSunInfo) -> () in
                if let res = resSunInfo {
                    self.modelController.sunInfo = res
                    
                    self.performSegue(withIdentifier: "doneSettingSegue", sender: nil)
                }
            })
        } else {
            alertPopUp(title: "Pick location and date", message: "Don't leave empty fields!")
        }
        
    }
    
    @IBAction func searchLocationAction(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.formattedAddress.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields

        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dataDisplayViewController = segue.destination as? DataDisplayViewController {
            dataDisplayViewController.modelController = modelController
        }
        if let mapViewController = segue.destination as? MapLocationViewController {
            mapViewController.modelController = modelController
        }
    }
}



extension SetupDataViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        modelController.locationDate.adress = place.formattedAddress!
        modelController.locationDate.coordinates.latitude = "\(place.coordinate.latitude)"
        modelController.locationDate.coordinates.longitude = "\(place.coordinate.longitude)"
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
