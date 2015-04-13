//
//  ViewController.swift
//  Memorable Places
//
//  Created by Francisco de la Pena on 2/23/15.
//  Copyright (c) 2015 ___QuixoteLabs___. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var myPlaces: [CLPlacemark] = [CLPlacemark]()

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // MapView Initialization
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        
        var latitude: CLLocationDegrees = 37.790706
        
        var longitud: CLLocationDegrees = -122.409719
        
        var center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitud)
        
        var latDelta: CLLocationDegrees = 0.01
        
        var longDelta: CLLocationDegrees = 0.01
        
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        var region: MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        
        mapView.setRegion(region, animated: true)
        
        // CLLocation Manager Initialization
        
        self.locationManager.delegate = self
        
        var status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case CLAuthorizationStatus.AuthorizedAlways:
            
            println("AuthorizedAlways")
            
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            
            println("AuthorizedWhenInUse")
            
        case CLAuthorizationStatus.Denied:
            
            println("Denied")
        
        case CLAuthorizationStatus.NotDetermined:
            
            println("NotDetermined")
            
        case CLAuthorizationStatus.Restricted:
            
            println("Restricted")
            
        default:
            
            println("None")

        }
        
        if (status == CLAuthorizationStatus.Restricted || status == CLAuthorizationStatus.Denied) {
            
            println("Prrrrr")
        
        } else {
            
            self.locationManager.requestWhenInUseAuthorization()
            
            self.locationManager.startUpdatingLocation()

        }
        
        // Gesture Recognizer
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "storePoint")
        
        longPressGestureRecognizer.minimumPressDuration = 1
        
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func storePoint () -> Void {
        
        var touchPoint: CGPoint = longPressGestureRecognizer.locationInView(mapView)
        
        var pointInMapView: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
        var newLocation: CLLocation = CLLocation(latitude: pointInMapView.latitude, longitude: pointInMapView.longitude)
        
        
        
        var myGeoCoder: CLGeocoder = CLGeocoder()
        
        myGeoCoder.reverseGeocodeLocation(newLocation, completionHandler: {
            (placemarkArray:[AnyObject]!, error:NSError!) -> Void in
            
            var placeMark: CLPlacemark = placemarkArray[0] as! CLPlacemark
            
            var alreadyPresent: Bool = false
            
            for var i = 0; i < myPlaces.count; i++ {
                
                if (myPlaces[i].name == placeMark.name) {
                    
                    println("--> \(myPlaces[i].name)")
                    alreadyPresent = true
                    
                }
            }
            
            if !alreadyPresent {
                
                myPlaces.append(placeMark)
                
                println("Saved!!")
                
                alreadyPresent = false
                
            }
            
        })
        
        
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        if (locations == nil ) {
            
            println("No tengo nada que darte :(")
            
        } else {
            
            var currentLocation: CLLocation = locations[(locations.count)-1] as! CLLocation
            
            //println("\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
            
            mapView.setCenterCoordinate(currentLocation.coordinate, animated: true)
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Ha petado: \(error)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

