//
//  ImageDetailsViewController.swift
//  TrailMapper
//
//  Created by Tim Sutton on 2017/09/16.
//  Copyright © 2017 Tim Sutton. All rights reserved.
//

import UIKit
import CoreLocation

class ImageDetailsViewController: UIViewController {
    
    // for storing last coord - passed from previous controller in seque
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @IBOutlet weak var imageDetailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageDetailsLabel.text = "Longitude: \(location.longitude)\nLatitude: \(location.latitude)"
        
        
        // Logic below for zooming an apple maps control to the point ... we will add this later....
        
        //let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        //let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        //let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        //map.setRegion(region, animated: true)
        //self.map.showsUserLocation = true
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
