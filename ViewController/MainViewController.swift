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

class MainViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var mainMapView: MKMapView!
    
    var lati: CLLocationDegrees?
    var long: CLLocationDegrees?
    let myPin: MKPointAnnotation = MKPointAnnotation()
    var myPinArray: [MKAnnotation] = []
    //var rest = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainMapView.delegate = self
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
            //mainMapView.region = region
            
            print("latitude: \(lati!)\nlongitude: \(long!)")
        }
    }
    
    @IBAction func range300Btn(_ sender: Any) {
        mainMapView.removeAnnotations(myPinArray)
        myPinArray = []
        get(rangenumber: 1)
    }
    
    @IBAction func range500Btn(_ sender: Any) {
        mainMapView.removeAnnotations(myPinArray)
        myPinArray = []
        get(rangenumber: 2)
    }
    
    @IBAction func range1000Btn(_ sender: Any) {
        mainMapView.removeAnnotations(myPinArray)
        myPinArray = []
        get(rangenumber: 3)
    }
    
    @IBAction func range2000Btn(_ sender: Any) {
        mainMapView.removeAnnotations(myPinArray)
        myPinArray = []
        get(rangenumber: 4)
    }
    
    @IBAction func range3000Btn(_ sender: Any) {
        mainMapView.removeAnnotations(myPinArray)
        myPinArray = []
        get(rangenumber: 5)
    }
    
    // HTTP-GET
    func get(rangenumber: Int) {
        // create the url-request
        
        let urlString = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=1b68697c1b2147d6b721390b54ea9530&latitude=\(self.lati!)&longitude=\(self.long!)&range=\(rangenumber)&hit_per_page=100&"
        let component = URLComponents(string: urlString)!
        
        URLSession.shared.dataTask(with: component.url!) { (data, response, error) in
            
            let gNaviResponse = try? JSONDecoder().decode(GNaviResponse<Restaurant>.self, from: data!
            )
            
            //self.rest = gNaviResponse!.rest
            self.mainMapView.removeAnnotation(self.myPin)
            
            for i in 0...gNaviResponse!.rest.count-1 {
                // ピンを生成.
                let myPin = CustomAnnotation()
                
                let myLati: Double = atof(gNaviResponse!.rest[i].latitude)
                
                let myLong: Double = atof(gNaviResponse!.rest[i].longitude)
                
                let coordinate = CLLocationCoordinate2DMake(myLati, myLong)
                
                
                // 座標を設定.
                myPin.coordinate = coordinate
                
                // タイトルを設定.
                myPin.title = gNaviResponse!.rest[i].name
                
                // サブタイトルを設定.
                myPin.subtitle = gNaviResponse!.rest[i].access.line
                
                myPin.imageURL = gNaviResponse!.rest[i].image_url.shop_image1
                self.myPinArray.append(myPin)
                
            }
            DispatchQueue.main.async {
                self.mainMapView.addAnnotations(self.myPinArray)
            }
            
        }.resume()
        
    }
    
    
    /* func mainMapView(_ mainMapView: MKMapView, viewFor myPin: MKAnnotation) -> MKAnnotationView? {
     let markerAnnotationView = MKMarkerAnnotationView(annotation: myPin, reuseIdentifier: "myPin")
     markerAnnotationView.isDraggable = true
     markerAnnotationView.canShowCallout = true
     markerAnnotationView.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
     return markerAnnotationView
     }
     */
    //addAnnotationした際に呼ばれるデリゲートメソッド
    func mapView(_ mainMapView: MKMapView, viewFor myPin: MKAnnotation) -> MKAnnotationView? {
        
        if myPin is MKUserLocation { return nil }
        
        let identifier = "myPin"
        var annotationView: MKAnnotationView!
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: myPin, reuseIdentifier: identifier)
        }
        
        
        // pinに表示する画像を指定
        if NSStringFromClass(type(of: myPin)).components(separatedBy: ".").last! == "CustomAnnotation" {
            annotationView.image = getImageByUrl(url:(myPin as! CustomAnnotation).imageURL)
        }
        
        
        annotationView.annotation = myPin
        annotationView.canShowCallout = true
        
        
        let rect:CGRect = CGRect(x:0, y:0, width:50, height:50)
        
        annotationView.frame = rect;
        
        return annotationView
    }
    
    //ピンのタップ時
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    
    func getImageByUrl(url: String?) -> UIImage{
        if let url = URL(string: url!) {
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)!
            } catch let err {
                print("Error : \(err.localizedDescription)")
            }
        }
        
        return UIImage(named: "pin")!
    }
}
