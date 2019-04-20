//
//  PopUpDatePickViewController.swift
//  SunsetSunrise
//
//  Created by Sebastian on /18/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import CoreLocation

class PopUpDatePickViewController: UIViewController {
    @IBOutlet weak var dateTextField: UITextField!
    let datePicker = UIDatePicker()
    var modelController: ModelController!
    var loadIndicator: UIActivityIndicatorView?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerAndView()
        setUpToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateTextField.text = modelController.locationDate.date
    }
    
    // MARK: - View setups
    
    func setupPickerAndView() {
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        
        datePicker.backgroundColor = .lightGray
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
    }
    
    func setUpToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = UIColor.darkGray
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        doneBtn.tintColor = .gray
        
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dateTextField.inputAccessoryView = toolBar
    }
    
    // MARK: - Loading Animation
    
    func startLoadAnimation() {
        loadIndicator = UIActivityIndicatorView()
        
        loadIndicator!.center = view.center
        loadIndicator!.hidesWhenStopped = true
        loadIndicator!.style = .gray
        view.addSubview(loadIndicator!)
        loadIndicator!.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopLoadAnimation() {
        loadIndicator!.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: - Button actions, segue prepare
    
    @objc func dismissPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        modelController.locationDate.date = formatter.string(from: datePicker.date)
        dateTextField.text = modelController.locationDate.date
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dataDisplayViewController = segue.destination as? DataDisplayViewController {
            dataDisplayViewController.modelController = modelController
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if self.dateTextField.text != "" {
            startLoadAnimation()
            let fetchSI = FetchSunInfo(url: RequestURL(latitude: Float(modelController.locationDate.coordinates.latitude)!, longitute: Float(modelController.locationDate.coordinates.longitude)!, date: modelController.locationDate.date))
            fetchSI.fetch(completion: { (resSunInfo) -> () in
                if let res = resSunInfo {
                    self.modelController.setSunInfo(info: res)
                    self.stopLoadAnimation()
                    self.performSegue(withIdentifier: "doneSettingDateSegue", sender: nil)
                }
            })
        } else {
            alertPopUp(title: "Pick date", message: "Don't leave empty fields!")
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
}
