//
//  FirstViewController.swift
//  Weather
//
//  Created by Administrator on 25/02/2019.
//  Copyright © 2019 Amplitudo. All rights reserved.
//

import UIKit
import Moya
import Kingfisher
import MapKit

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var airPressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Today"
        weatherCall()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("lat=\(localValue.latitude)")
        print("lon=\(localValue.longitude)")
        latitude = localValue.latitude
        longtitude = localValue.longitude
    }
   
    func weatherCall(){
        let provider = MoyaProvider<Vrijeme>()
        provider.request(.vrijeme) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let decoded = try? JSONDecoder().decode(Welcome.self, from: data)
                DispatchQueue.main.async {
                    self.cityName.text = "\(decoded?.city?.name ?? "N/A"), \(decoded?.city?.country ?? "N/A")"
                    self.airPressure.text = "\(decoded?.list?[0].main?.pressure ?? 0.00) Pa"
                    self.humidity.text = "\(decoded?.list?[0].main?.humidity ?? 0) %"
                    self.temperature.text = "\(decoded?.list?[0].main?.temp ?? 0) ˚C | \(decoded?.list?[0].weather?[0].main ?? "N/A")"
                    self.windSpeed.text = "\(decoded?.list?[0].wind?.speed ?? 0) m/s"
                    let myURL = URL(string:"http://openweathermap.org/img/w/\(decoded?.list?[0].weather?[0].icon ?? "01d").png")
                    KingfisherManager.shared.retrieveImage(with: myURL!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                        self.weatherIcon.image = image!
                   })
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {  if var top = self.view?.window?.rootViewController {
        while let presentedViewController = top.presentedViewController {
            top = presentedViewController
        }
        let activityVC = UIActivityViewController(activityItems: ["This is an array of items that will be shared. Including Images, Numbers, and text (like this)"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        top.present(activityVC, animated: true, completion: nil)
        }
    }
}

