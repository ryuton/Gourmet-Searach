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
import Darwin

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    @IBOutlet weak var mainMapView: MKMapView!
    
    var lati: CLLocationDegrees?
    var long: CLLocationDegrees?
     let myPin: MKPointAnnotation = MKPointAnnotation()
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
            get(rangenumber: 2)
        }
    }
    
    @IBAction func range300Btn(_ sender: Any) {
        get(rangenumber: 1)
    }
    
    @IBAction func range500Btn(_ sender: Any) {
        get(rangenumber: 2)
    }
    
    @IBAction func range1000Btn(_ sender: Any) {
        get(rangenumber: 3)
    }
    
    @IBAction func range2000Btn(_ sender: Any) {
        get(rangenumber: 4)
    }
    
    @IBAction func range3000Btn(_ sender: Any) {
        get(rangenumber: 5)
    }
    
    // HTTP-GET
    func get(rangenumber: Int) {
        // create the url-request
        
        let urlString = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=1b68697c1b2147d6b721390b54ea9530&latitude=\(self.lati!)&longitude=\(self.long!)&range=\(rangenumber)&hit_per_page=100"
        let component = URLComponents(string: urlString)!
        
        URLSession.shared.dataTask(with: component.url!) { (data, response, error) in
            
            let gNaviResponse = try? JSONDecoder().decode(GNaviResponse<Restaurant>.self, from: data!
            )
            for i in 0...gNaviResponse!.rest.count-1 {
                // ピンを生成.
                let myPin: MKPointAnnotation = MKPointAnnotation()
                
                let myLati: Double = atof(gNaviResponse!.rest[i].latitude)
                
                let myLong: Double = atof(gNaviResponse!.rest[i].longitude)
                
                let coordinate = CLLocationCoordinate2DMake(myLati, myLong)
                
                
                // 座標を設定.
                myPin.coordinate = coordinate
                
                // タイトルを設定.
                myPin.title = gNaviResponse!.rest[i].name
                
                // サブタイトルを設定.
                myPin.subtitle = gNaviResponse!.rest[i].nameKana
                // MapViewにピンを追加.
                self.mainMapView.addAnnotation(myPin)

            }
        }.resume()
        
    }
    // mapViewのデリゲート
       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           // MKPinAnnotationViewを宣言
           let annoView = MKPinAnnotationView()
           // MKPinAnnotationViewのannotationにMKAnnotationのAnnotationを追加
           annoView.annotation = annotation
           // ピンの画像を変更
           annoView.image = UIImage(named: "swift_logo")
           // 吹き出しを使用
           annoView.canShowCallout = true
           // 吹き出しにinfoボタンを表示
           annoView.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)

           return annoView
       }
}
