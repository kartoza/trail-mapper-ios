//
//  TMTrailViewController.swift
//  TrailMapper
//
//  Created by Tim Sutton on 2018/01/08.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import CoreLocation
import UIKit

class TMTrailViewController:
    UIViewController,
    CLLocationManagerDelegate,
    UINavigationControllerDelegate {
    
    //MARK:- IBOutlets
    
    
    //MARK:- Variables & Constants
    let locationManager = CLLocationManager() // for getting GPS coords
    var currentLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()// for storing last coord
    
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // configuration for things relating to location manager.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
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
    
    // MARK: - Custom Class Functions
    
    // MARK:- Core Location Methods
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation])
    {
        // I searched long and hard to get the location direct from the image.
        // You can get it from a photo roll image but not one direclty captured
        // by using the camera. See https://stackoverflow.com/a/42888731
        // In particular read all the comments there carefully as there are a
        // lot of red herrings where the question is answered based on useing
        // the photo roll.  Because of all these issues, I opted to get the
        // location direct from the GPS rather than the image
        let location = locations[0]
        self.currentLocationCoordinate = location.coordinate
        print("Coordinates: \(self.currentLocationCoordinate.latitude)")
        locationManager.stopUpdatingLocation()
    }
}
