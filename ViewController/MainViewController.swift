//
//  ViewController.swift
//  FenrirGourmet
//
//  Created by 上野隆斗 on 2020/03/14.
//  Copyright © 2020 ryuton. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    @IBOutlet weak var mainMapView: MKMapView!
    
    var lati: CLLocationDegrees?
    var long: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLocationManager()
        
        
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        self.locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        case .denied:
            print("許可してください")
        // 許可しないボタンをタップしたとき
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        lati = location?.coordinate.latitude
        long = location?.coordinate.longitude
        
        if let coordinate = locations.last?.coordinate {
            // 現在地を拡大して表示する
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mainMapView.region = region
            
        print("latitude: \(lati!)\nlongitude: \(long!)")
            get()
    }
}
    
    // HTTP-GET
    func get() {
        // create the url-request
        let urlString = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=3f123b61493fab2cf44e27a71320d604&latitude=\(self.lati!)&longitude=\(self.long!)c&"
        let component = URLComponents(string: urlString)!

        URLSession.shared.dataTask(with: component.url!) { (data, response, error) in
        
            let gNaviResponse = try? JSONDecoder().decode(GNaviResponse<Restaurant>.self, from: data!
            )
            print(gNaviResponse?.rest ?? "")
        }.resume()

    }
    
}
