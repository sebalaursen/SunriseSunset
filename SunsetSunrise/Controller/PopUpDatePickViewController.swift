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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerAndView()
        setUpToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateTextField.text = modelController.locationDate.date
        modelController.locationDate.timeDifference = 0
    }
    
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
        
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dateTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        modelController.locationDate.date = formatter.string(from: datePicker.date)
        dateTextField.text = modelController.locationDate.date
        modelController.getTimeZone()
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dataDisplayViewController = segue.destination as? DataDisplayViewController {
            dataDisplayViewController.modelController = modelController
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if self.dateTextField.text != "" {
            let fetchSI = FetchSunInfo(url: RequestURL(latitude: Float(modelController.locationDate.coordinates.latitude)!, longitute: Float(modelController.locationDate.coordinates.longitude)!, date: modelController.locationDate.date))
            fetchSI.fetch(completion: { (resSunInfo) -> () in
                if let res = resSunInfo {
                    self.modelController.sunInfo = res
                    
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
