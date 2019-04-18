//
//  ViewController.swift
//  SunsetSunrise
//
//  Created by Sebastian on /17/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import GooglePlaces

class MainViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sunImage: UIImageView!
    @IBOutlet weak var currentBtn: UIButton!
    @IBOutlet weak var chooseBtn: UIButton!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateSun()
    }
    
    private func animateSun() {
        if sunImage != nil {
            sunImage.image = sunImage.image?.withRenderingMode(.alwaysTemplate)
            let midlePoint = CGPoint(x: self.nameLabel.frame.midX - self.sunImage.frame.width/2,
                                     y: self.sunImage.frame.origin.y - self.nameLabel.frame.width/2)
            let endPoint = CGPoint(x: self.sunImage.frame.maxX + self.nameLabel.frame.width + 11.5,
                                   y: self.sunImage.frame.origin.y)
            
            UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.sunImage.frame.origin.x = midlePoint.x
                    self.sunImage.frame.origin.y = midlePoint.y
                    self.sunImage.tintColor = UIColor(red: 253/255, green: 236/255, blue: 79/255, alpha: 1)
                    
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    self.sunImage.frame.origin.x = endPoint.x
                    self.sunImage.frame.origin.y = endPoint.y
                    self.sunImage.tintColor = UIColor(red: 246/255, green: 202/255, blue: 122/255, alpha: 1)
                })
            }) { (finished) in
                UIView.animate(withDuration: 0.8, animations: {
                    self.currentBtn.alpha = 1
                    self.chooseBtn.alpha = 1
                    self.sunImage.alpha = 0
                }) { (finished) in
                    self.sunImage.removeFromSuperview()
                }
            }
        }
    }

    @IBAction func currentLocDateBtnAction(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .denied:
            alertLocationAccess()
        case .authorizedAlways:
            performSegue(withIdentifier: "currentSegue", sender: nil)
        case .authorizedWhenInUse:
            performSegue(withIdentifier: "currentSegue", sender: nil)
        }
    }
    
    @IBAction func chooseLocDateBtnAction(_ sender: Any) {
        performSegue(withIdentifier: "chooseSegue", sender: nil)
    }
    
    func alertLocationAccess() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need location tracking access",
            message: "Is needed to use this app",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

