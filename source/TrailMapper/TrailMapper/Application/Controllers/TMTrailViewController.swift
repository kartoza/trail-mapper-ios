//
//  TMTrailViewController.swift
//  TrailMapper
//
//  Created by Tim Sutton on 2018/01/08.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import ALCameraViewController
import CoreLocation
import UIKit

class TMTrailViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var trailImage: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var txtFieldTrailName: UITextField!
    @IBOutlet weak var btnSelectLocation: UIButton!
    @IBOutlet weak var btnAddNotes: UIButton!
    
    //MARK:- Variables & Constants
    var currentLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()// for storing last coord
    var trailImageLocalPath = "No Image available"
    let newTrailModel = TMTrails.init(object: [])
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add save trail button in navigation bar
        let saveTrailButton = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(self.btnSaveTrailTapped))
        self.navigationItem.rightBarButtonItem = saveTrailButton

        //Start updating user current location through TMLocationManager
        TMLocationManager.sharedInstance.startUpdatingLocation()

        //Generate UUID for new trail
        newTrailModel.guid = UUID().uuidString

        // Get all trails for debug purpose, need to be remove afterwords
        self.getAllTrails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == TMConstants.kSegueCreateTrailsToMap {
            let locationMapController = segue.destination as! TMTrailMapLocationViewController
            locationMapController.parentControllerForMapVC = .kCreateTrail
        }
    }
    
    // MARK: - Custom Class Functions
    @IBAction func btnShowOnMapTapped(_ sender: Any) {
        self.performSegue(withIdentifier: TMConstants.kSegueCreateTrailsToMap, sender: self)
    }

    @IBAction func getImage(_ sender: Any) {
        print("Get Image Button tapped")
        let cameraViewController = CameraViewController { [weak self] image, asset in
            // Do something with your image here.
            self?.trailImage.image = image
            self?.dismiss(animated: true, completion: nil)
            self?.addImageButton.setTitle("Change image ...", for: UIControlState.normal)

            // Save current capture image to local refernece path through utility funtion (SaveImage)
            self?.trailImageLocalPath = TMUtility.sharedInstance.saveImage(imagetoConvert: image!, name: "trail\(String(describing: self?.newTrailModel.guid!)).png")
        }
        
        present(cameraViewController, animated: true, completion: nil)

    }

    // Save btn event : To save all trail info into Local database
    @objc func btnSaveTrailTapped() {

        if self.validateTrailInputs() {
            //Get latest current location co-ordinates
            self.currentLocationCoordinate = TMLocationManager.sharedInstance.latestLocationCoordinate
            //update trail model from inputs
            newTrailModel.name = self.txtFieldTrailName.text
            newTrailModel.notes = "notes txt" // Hard coded value , need to implement Add notes feature
            newTrailModel.image = self.trailImageLocalPath
            // Hard coded value , need to discuss about this
            newTrailModel.id = 3
            newTrailModel.geom = "POINT(\(self.currentLocationCoordinate.latitude ) \(self.currentLocationCoordinate.longitude ))"
            newTrailModel.offset = 3

            let dataManagerWrapper = TMDataWrapperManager()

            dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
                if error == nil {
                    AlertManager.showCustomAlert(Title: TMConstants.kApplicationName, Message: TMConstants.kAlertTrailsSaveSuccess, PositiveTitle: TMConstants.kAlertTypeOK, NegativeTitle: "", onPositive: {
                        // On successful save operation move back to main menu.
                        self.navigationController?.popViewController(animated: true)
                    }, onNegative: {
                        //Do nothing
                    })
                }else {
                    AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message: TMConstants.kAlertTrailsSaveFail, PositiveTitle: TMConstants.kAlertTypeOK)
                }
            }
            dataManagerWrapper.saveTrailToLocalDatabase(trailModel:newTrailModel )

        }
    }

    // MARK: - Custom Class Functions

    // Validate the input parameters for saving trail
    func validateTrailInputs()-> Bool {
        if (self.txtFieldTrailName.text?.isEmpty)! {
            AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message:TMConstants.kAlertTrailsVailidName, PositiveTitle: TMConstants.kAlertTypeOK)
            return false
        }

        return true
    }

    // To get all the trails which is available in local storage
    func getAllTrails() {
        let dataManagerWrapper = TMDataWrapperManager()

        dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
            if (responseArray?.count)! > 0 {
                print("Trail Array --->", responseArray ?? "")

            }
        }
        dataManagerWrapper.callToGetTrailsFromDB(trailGUID: "")
    }

    //MARK: - UITextField delgate methods

    // This will be useful for returning keyboard if user hits return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
