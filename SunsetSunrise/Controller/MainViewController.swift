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
    var modelController: ModelController!
    var locManager = CoreLocationManadger()
    var currentLocation = CLLocationCoordinate2D()
    var loadIndicator: UIActivityIndicatorView?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateSun()
        modelController = ModelController()
    }
    
    // MARK: - Animation
    
    private func animateSun() {
        if sunImage != nil {
            sunImage.image = sunImage.image?.withRenderingMode(.alwaysTemplate)
            let middlePoint = CGPoint(x: self.nameLabel.frame.midX - self.sunImage.frame.width/2,
                                     y: self.sunImage.frame.origin.y - self.nameLabel.frame.width/1.9)
            let endPoint = CGPoint(x: self.sunImage.frame.maxX + self.nameLabel.frame.width + 11.5,
                                   y: self.sunImage.frame.origin.y)
            
            UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.sunImage.frame.origin.x = middlePoint.x
                    self.sunImage.frame.origin.y = middlePoint.y
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
    
    // MARK: - Location acces alert
    
    func alertLocationAccess() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need location tracking access",
            message: "Is needed to use this app",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.view.tintColor = .gray
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
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
    
    @IBAction func currentLocDateBtnAction(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .denied:
            alertLocationAccess()
        case .authorizedAlways:
            startLoadAnimation()
            locManager.startTracking()
            processLocationInfo()
        case .authorizedWhenInUse:
            startLoadAnimation()
            locManager.startTracking()
            processLocationInfo()
        }
    }
    
    @IBAction func chooseLocBtnAction(_ sender: Any) {
        locManager.stopTracking()
        performSegue(withIdentifier: "chooseLocSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chooseDataDisplayViewController = segue.destination as? SetupDataViewController {
            chooseDataDisplayViewController.modelController = modelController
        }
        if let dataDisplayViewController = segue.destination as? DataDisplayViewController { 
            dataDisplayViewController.modelController = modelController
        }
    }

    // MARK: - Fetching info
    
    func processLocationInfo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.modelController.locationDate.adress = "Your location"
            self.modelController.locationDate.coordinates.latitude = "\(self.currentLocation.latitude)"
            self.modelController.locationDate.coordinates.longitude = "\(self.currentLocation.longitude)"
            print(self.modelController.locationDate.coordinates.latitude)
            print(self.modelController.locationDate.coordinates.longitude)

            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            print(formatter.string(from: date))
            self.modelController.locationDate.date = formatter.string(from: date)
            self.modelController.getTimeZone(completion: {(complete) -> () in
                if complete {
                    self.fetchSunInfo()
                }
            })
            self.locManager.stopTracking()
        }
    }
    func fetchSunInfo() {
        let fetchSI = FetchSunInfo(url: RequestURL(latitude: Float(modelController.locationDate.coordinates.latitude)! , longitute: Float(modelController.locationDate.coordinates.longitude)! , date: modelController.locationDate.date))
        fetchSI.fetch(completion: { (resSunInfo) -> () in
            if let res = resSunInfo {
                self.modelController.setSunInfo(info: res)
                self.stopLoadAnimation()
                self.performSegue(withIdentifier: "showDataWithCurLocSegue", sender: nil)
            }
        })
    }

}

extension MainViewController: CoreLocDelegate {
    func getCoordinates(location: CLLocation) {
        print("lat: \(location.coordinate.latitude); lon: \(location.coordinate.longitude)")
        currentLocation.latitude = location.coordinate.latitude
        currentLocation.longitude = location.coordinate.longitude
    }
}

