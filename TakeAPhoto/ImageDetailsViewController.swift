//
//  ImageDetailsViewController.swift
//  TakeAPhoto
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
        self.imageDetailsLabel.text = "\(location.longitude) : \(location.latitude)"
        
    }
    
    // Need to make sense of this!!!
    // Need to make sense of this!!! the Red part of the method should
    // Need to make sense of this!!! reference another controller
    // Need to make sense of this!!!
    @IBAction func unwindToRed(unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
