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
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        
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
        performSegue(withIdentifier: "editCurrentSegue", sender: nil)
    }
}
