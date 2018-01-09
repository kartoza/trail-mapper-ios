//
//  TMTrailLocationViewController.swift
//  TrailMapper
//
//  Created by Tim Sutton on 2018/01/09.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit
import MapKit

class TMTrailLocationViewController: UIViewController {

    var currentLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()// for storing last coord
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
