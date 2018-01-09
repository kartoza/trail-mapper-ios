//
//  TMTrailMapLocationVControllerViewController.swift
//  TrailMapper
//
//  Created by Netwin on 09/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TMTrailMapLocationVControllerViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{

    //MARK:- IBOutlets
    @IBOutlet weak var trailLocationMapView: MKMapView!

    //MARK:- Variables & Constants
    let locationManager = CLLocationManager() // for getting GPS coords
    var currentLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()// for storing last coord
    let regionRadius: CLLocationDistance = 1000

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        trailLocationMapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK:- Core Location Methods
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        self.currentLocationCoordinate = location.coordinate
        print("Coordinates: \(self.currentLocationCoordinate.latitude)")
        self.getCenterMapOnLocation(location: location)
    }

    func getCenterMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        trailLocationMapView.setRegion(coordinateRegion, animated: true)
    }

}
