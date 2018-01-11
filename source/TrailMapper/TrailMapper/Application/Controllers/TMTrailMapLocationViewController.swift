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

class TMTrailMapLocationViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{

    enum parentController : Int {
        case kCreateTrail = 0
        case kCreateTrailSection
        case kMainMenu
    }

    //MARK:- IBOutlets
    @IBOutlet weak var trailLocationMapView: MKMapView!

    //MARK:- Variables & Constants
    let locationManager = CLLocationManager() // for getting GPS coords
    var currentLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()// for storing last coord
    let regionRadius: CLLocationDistance = 1000
    var parentControllerForMapVC = parentController.kCreateTrail
    var currentTrailSection = TMTrailSections.init(object: [])

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Show users current location icon on map
        trailLocationMapView.showsUserLocation = true

        switch parentControllerForMapVC {
        case .kCreateTrail:
            self.title = "Current Location"
        case .kCreateTrailSection:
            self.addCostomNavigationButtonsToView()
            self.getCurrentRecordingTrailSection(trailSectionGUID: TMUtility.sharedInstance.recordingTrailSectionGUID)
        case .kMainMenu :
            self.addCostomNavigationButtonsToView()
            self.getCurrentRecordingTrailSection(trailSectionGUID: TMUtility.sharedInstance.recordingTrailSectionGUID)
        }
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

    // Used this fuctions to show centralize/zoom users current location on map.
    func getCenterMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        trailLocationMapView.setRegion(coordinateRegion, animated: true)
    }

    func addCostomNavigationButtonsToView() {
        let stopTrailRecordingButton = UIBarButtonItem.init(title: "Stop", style: .done, target: self, action: #selector(self.btnStopTrailRecordingTapped))
        self.navigationItem.rightBarButtonItem = stopTrailRecordingButton

        let customBackButton = UIBarButtonItem.init(title: "Back", style: .done, target: self, action: #selector(self.btnCustomBackTapped))
        self.navigationItem.leftBarButtonItem = customBackButton
    }

    @objc func btnCustomBackTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func btnStopTrailRecordingTapped() {
        // Stop recording here
        AlertManager.showCustomAlert(Title: TMConstants.kApplicationName, Message: TMConstants.kAlertTrailSectionRecordingStop, PositiveTitle: TMConstants.kAlertTypeYES, NegativeTitle: TMConstants.kAlertTypeNO, onPositive: {
            TMUtility.sharedInstance.recordingTrailSectionGUID = ""
            self.navigationController?.popToRootViewController(animated: true)
        }) {
            // No Action on "No" button press.
        }
    }

    // Get current recording trail section from local DB
    func getCurrentRecordingTrailSection(trailSectionGUID:String) {
        let dataManagerWrapper = TMDataWrapperManager()

        dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
            if (responseArray?.count)! > 0 {
                self.currentTrailSection = responseArray?.object(at: 0) as! TMTrailSections
                self.title = self.currentTrailSection.name ?? ""
            }
        }
        dataManagerWrapper.callToGetTrailSectionFromDB(trailSectionGUID: trailSectionGUID)
    }

}
