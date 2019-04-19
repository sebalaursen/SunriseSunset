//
//  DataDisplayViewController.swift
//  SunsetSunrise
//
//  Created by Sebastian on /17/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class DataDisplayViewController: UIViewController {
    
    var modelController: ModelController!

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var solarNoonLabel: UILabel!
    @IBOutlet weak var dayLengthLabel: UILabel!
    var datePicker = UIDatePicker()
    var picker: UIView!
    
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    func setupDatePicker() {
        picker = UIView(frame: CGRect(x: 0, y: view.frame.height*2/3,
                                          width: view.frame.width, height: view.frame.height*1/3))
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = UIColor.darkGray
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: toolBar.frame.height, width: view.frame.width, height: picker.frame.height - toolBar.frame.height))
        datePicker.backgroundColor = .lightGray
        datePicker.datePickerMode = .date
        
        picker.addSubview(datePicker)
        picker.addSubview(toolBar)
    }
    
    @objc func dismissPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        modelController.locationDate.date = formatter.string(from: datePicker.date)
        dateLabel.text = modelController.locationDate.date
        picker.removeFromSuperview()
    }
    
    
    
    // MARK: - Labels setup
    
    func setup() {
        locationLabel.text = modelController.locationDate.adress
        dateLabel.text = modelController.locationDate.date
        sunriseLabel.text = modelController.sunInfo.sunrise
        sunsetLabel.text = modelController.sunInfo.sunset
        solarNoonLabel.text = modelController.sunInfo.solar_noon
        dayLengthLabel.text = modelController.sunInfo.day_length
    }
    
    // MARK: - Action

    @IBAction func editAction(_ sender: Any) {
        view.addSubview(picker)
    }
}
