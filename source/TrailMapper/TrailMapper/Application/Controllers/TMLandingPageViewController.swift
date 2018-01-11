//
//  ViewController.swift
//  TrailMapper
//
//  Created by Tim Sutton on 2018/01/08.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit

class TMLandingPageViewController: UIViewController {

    //MARK:- IBOutlets

    @IBOutlet weak var btnStartTrailSection: UIButton!

    //MARK:- Variables & Constants


    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // for the landing page only we will hide the navigation controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        if TMUtility.sharedInstance.recordingTrailSectionGUID != "" {
            self.btnStartTrailSection.setTitle("Recording is going on", for: .normal)
        }else {
            self.btnStartTrailSection.setTitle("Start recording a trail section", for: .normal)
        }

        self.getAllTrails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == TMConstants.kSegueMenuToTrailSectionMap {
            let locationMapController = segue.destination as! TMTrailMapLocationViewController
            locationMapController.parentControllerForMapVC = .kMainMenu
        }
    }

    @IBAction func btnCreateTrailClicked(_ sender:Any) {
       // TMAPIManager.sharedInstance.getTrails()
        TMAPIManager.sharedInstance.getTrail(trailId: 1)
    }

    @IBAction func btnStartRecordingTrailSectionClicked(_ sender:Any) {
        // TMAPIManager.sharedInstance.getTrails()
        if (TMUtility.sharedInstance.recordingTrailSectionGUID != "" )  {
            self.performSegue(withIdentifier: TMConstants.kSegueMenuToTrailSectionMap, sender: self)
        }else {
            self.performSegue(withIdentifier: TMConstants.kSegueGoToAllTrails, sender: self)
        }
    }

    // Get All trails list for checking purpose
    func getAllTrails() {
        let dataManagerWrapper = TMDataWrapperManager()

        dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
            if (responseArray?.count)! > 0 {
                print("Trail Array --->", responseArray ?? "")

                for trailModel in responseArray! {
                    let trail = trailModel as! TMTrails
                    if (trail.guid == nil)  {
                        print(" Trails : \(String(describing: trail.name!)) needs to sync with server")
                    }
                }
            }
        }
        dataManagerWrapper.callToGetTrailsFromDB(trailGUID: "")
    }

}

