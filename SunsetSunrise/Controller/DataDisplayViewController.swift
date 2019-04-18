//
//  DataDisplayViewController.swift
//  SunsetSunrise
//
//  Created by Sebastian on /17/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class DataDisplayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func editAction(_ sender: Any) {
        performSegue(withIdentifier: "editCurrentSegue", sender: nil)
    }
}
