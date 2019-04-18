//
//  PopUpDatePickViewController.swift
//  SunsetSunrise
//
//  Created by Sebastian on /18/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class PopUpDatePickViewController: UIViewController {
    @IBOutlet weak var dateTextField: UITextField!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerAndView()
        setUpToolbar()
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
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
