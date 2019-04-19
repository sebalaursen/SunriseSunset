//
//  ViewControllerExtension.swift
//  SunsetSunrise
//
//  Created by Sebastian on /19/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

extension UIViewController {
    func alertPopUp(title: String, message: String) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.view.tintColor = .gray
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
