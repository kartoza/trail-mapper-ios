//
//  TMCreateTrailSectionVController.swift
//  TrailMapper
//
//  Created by Netwin on 11/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit
import ALCameraViewController
import CoreLocation

class TMCreateTrailSectionVController: UIViewController,UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var trailSectionImage: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var txtFieldTrailSectionName: UITextField!
    @IBOutlet weak var btnAddNotes: UIButton!

    //MARK:- Variables & Constants
    var currentLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var trailSectionImageLocalPath = "No Image available"
    let newTrailSectionModel = TMTrailSections.init(object: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add save trail section button in navigation bar
        let saveTrailSectionButton = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(self.btnSaveTrailSectionTapped))
        self.navigationItem.rightBarButtonItem = saveTrailSectionButton

        //Start updating user current location through TMLocationManager
        TMLocationManager.sharedInstance.startUpdatingLocation()

        //Generate UUID for new trail section
        newTrailSectionModel.guid = UUID().uuidString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == TMConstants.kSegueTrailSectionMap {
            let locationMapController = segue.destination as! TMTrailMapLocationViewController
            locationMapController.title = newTrailSectionModel.name
            locationMapController.parentControllerForMapVC = .kCreateTrailSection
        }
    }


    // MARK:- Image tap related methods
    @IBAction func btnAddImageTapped(_ sender: Any) {
        print("Get Image Button tapped")
        let cameraViewController = CameraViewController { [weak self] image, asset in
            // Do something with your image here.
            self?.trailSectionImage.image = image
            self?.dismiss(animated: true, completion: nil)
            self?.addImageButton.setTitle("Change image ...", for: UIControlState.normal)

            // Save current capture image to local refernece path through utility funtion (SaveImage)
            self?.trailSectionImageLocalPath = TMUtility.sharedInstance.saveImage(imagetoConvert: image!, name: "trail_sec\(String(describing: self?.newTrailSectionModel.guid!)).png")
        }

        present(cameraViewController, animated: true, completion: nil)

    }

    // Save btn event : To save all trail info into Local database
    @objc func btnSaveTrailSectionTapped() {

        if self.validateTrailInputs() {
            //Get latest current location co-ordinates
            self.currentLocationCoordinate = TMLocationManager.sharedInstance.latestLocationCoordinate
            //Update trail section model from inputs
            newTrailSectionModel.name = self.txtFieldTrailSectionName.text
            newTrailSectionModel.notes = "notes txt" // Hard coded value , need to implement Add notes feature
            newTrailSectionModel.imagePath = self.trailSectionImageLocalPath
            // Hard coded value , need to discuss about this
            newTrailSectionModel.id = 3
            newTrailSectionModel.geom = "POINT(\(self.currentLocationCoordinate.latitude ) \(self.currentLocationCoordinate.longitude ))"
            newTrailSectionModel.offset = 3

            let currentTimeStamp = "\(NSDate().timeIntervalSince1970 * 1000)"
            print("Current TimeStamp for new trail section --->",currentTimeStamp)

            let dataManagerWrapper = TMDataWrapperManager()

            dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
                    if error == nil {
                        AlertManager.showCustomAlert(Title: TMConstants.kApplicationName, Message: TMConstants.kAlertTrailSectionSaveSuccess, PositiveTitle: TMConstants.kAlertTypeOK, NegativeTitle: "", onPositive: {
                            // On successful save operation move back to main menu.
                            TMUtility.sharedInstance.recordingTrailSectionGUID = self.newTrailSectionModel.guid ?? ""
                            self.performSegue(withIdentifier: TMConstants.kSegueTrailSectionMap, sender: self)
                        }, onNegative: {
                            //Do nothing
                        })
                    }else {
                        AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message: TMConstants.kAlertTrailSectionSaveFail, PositiveTitle: TMConstants.kAlertTypeOK)
                    }
            }
            dataManagerWrapper.saveTrailSectionsToLocalDatabase(trailSectionModel:newTrailSectionModel )

        }
    }

    // MARK: - Custom Class Functions

    // Validate the input parameters for saving trail
    func validateTrailInputs()-> Bool {
        if (self.txtFieldTrailSectionName.text?.isEmpty)! {
            AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message:TMConstants.kAlertTrailsVailidName, PositiveTitle: TMConstants.kAlertTypeOK)
            return false
        }

        return true
    }

}
