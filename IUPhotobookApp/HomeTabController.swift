//
//  FirstViewController.swift
//  Lab27Xcode
//
//  Created by Brooks, Travis Raleigh on 4/16/19.
//  Copyright © 2019 C323 Spring 2019 - trabrook. All rights reserved.
//

// THIS IS CONNECTED TO THE HomeTab TAB

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,locationMarkerDelegate {
    
    
    private let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D? = nil

    @IBOutlet weak var MapView:MKMapView!
    var objects = [LocationData]()// get the data
    var settings = [Settings]()
    
    var notCentered = true
    
    var currentModel:LocationData?
    var annonAry = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationSuccessName = Notification.Name(rawValue: "gobackSuccessVC")
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(backSuccess(notification:)),
                                               name: notificationSuccessName, object: nil)
        self.configChange()
        self.MapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.update_location()
        settings = CoreModelData.shared.getAllSettingsData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //according to the segue to check the action
        if segue.identifier == "More" {
            let controller = segue.destination as! locationMarker
            controller.model = self.currentModel
            controller.delegate = self
        }
    }
    
   private func update_location() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    
    }
    
    // save the changed resource 
  private func configCenterMap() {
    
        self.MapView.region = MKCoordinateRegion(center: self.location!, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        self.MapView.setCenter(self.location!, animated: true)
        self.MapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
    }
    
 private func draw_map() {
        for model in objects {
            let annon = MKPointAnnotation()
            annon.title = model.title
            let latitude = Double(model.latitude ?? "0.00")
            let longitude = Double(model.longitude ?? "0.00")
            annon.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            annonAry.append(annon)
        
        }
        if annonAry.count > 0 {
            self.MapView.addAnnotations(annonAry)
        }
        
    }
    
    fileprivate func removeDrawMap() {
        self.MapView.removeAnnotations(self.annonAry)
        self.annonAry.removeAll()
    }
    
    fileprivate func configChange() {
        objects.removeAll()
        objects = CoreModelData.shared.getAllData()
    }
    
    @objc func backSuccess(notification: Notification) {
        self.configChange()
        self.removeDrawMap()
        self.draw_map()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = (locations.last?.coordinate)!
        
        
        if notCentered {
            self.configCenterMap()
            notCentered = false
        }
        
        self.draw_map()
        self.MapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
        self.MapView.showsUserLocation = true
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.currentModel = nil
        for model in objects {
            let latitude = Double(model.latitude ?? "0.00")
            let longitude = Double(model.longitude ?? "0.00")
            if view.annotation?.coordinate.latitude == latitude && view.annotation?.coordinate.longitude == longitude  {
                self.currentModel = model
            }
        }
        if let _ = self.currentModel {
            performSegue(withIdentifier: "More", sender: nil)
        }
    }

    func reloadDataWithModel() {
        self.configChange()
        self.removeDrawMap()
        self.draw_map()
    }
    
    
    
    @IBOutlet weak var settingsButton: UIButton!
    
    //Used for theme
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Tell the map it needs to be recentered
        //notCentered = true
        
        //FIRST GET COLORS
        let currentTheme = settings[0].currentTheme
        
        let aTheme = settings[Int(currentTheme)]
        
        let str = aTheme.background1
        
        let redEnd = str?.index((str?.startIndex)!, offsetBy: 2)
        let red = str?[...redEnd!]
        
        let greenStartIndex = str?.index((str?.startIndex)!, offsetBy: 4)
        let greenEndIndex = str?.index((greenStartIndex ?? nil)!, offsetBy: 2)
        let green = str?[greenStartIndex!...greenEndIndex!]
        
        let blueStartIndex = str?.index((greenEndIndex ?? nil)!, offsetBy: 2)
        let blueEndIndex = str?.index((blueStartIndex ?? nil)!, offsetBy: 2)
        let blue = str?[blueStartIndex!...blueEndIndex!]
        
        print("Red: \(red) \nGreen: \(green) \nBlue: \(blue)" )
        
        var redStr = ""
        redStr.append(String(red!))
        
        var greenStr = ""
        greenStr.append(String(green!))
        
        var blueStr = ""
        blueStr.append(String(blue!))
        
        var redInt = Int(redStr)
        var greenInt = Int(greenStr)
        var blueInt = Int(blueStr)
        
        //NOW COLOR THEM
        
        let crimson = UIColor(red: CGFloat(CGFloat(redInt!)/255), green:CGFloat(CGFloat(greenInt!)/255), blue: CGFloat(CGFloat(blueInt!)/255), alpha: 1)
        
        let cream = UIColor(red: 237, green: 235, blue: 235, alpha: 1)
        
        self.view.backgroundColor = crimson
        
        settingsButton.setTitleColor(crimson, for: .normal)
        settingsButton.backgroundColor = cream
    
    }
    
}
