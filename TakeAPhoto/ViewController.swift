//
//  ViewController.swift
//  TakeAPhoto
//
//  Created by Tim Sutton on 2017/08/16.
//  Copyright © 2017 Tim Sutton. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController,
                      UINavigationControllerDelegate,
                      UIImagePickerControllerDelegate,
                      CLLocationManagerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var imageDetails: String!
    let manager = CLLocationManager() // for getting GPS coords
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()// for storing last coord
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerControllerSourceType.camera
        imageController.allowsEditing = false
        disableSaveButton()
        self.present(imageController, animated: true)
        {
            // after it is complete
        }
    }
    
    @IBAction func savePhoto(_ sender: AnyObject) {
        // logic from https://stackoverflow.com/q/45277034
        let imageData = UIImagePNGRepresentation(image.image!)
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            image.image = selectedImage
            enableSaveButton()
        } else {
            // handle error
            disableSaveButton()
        }

        // I searched long and hard to get the location direct from the image.
        // You can get it form a photo roll image but not one direclty captured
        // by using the camera. See https://stackoverflow.com/a/42888731 
        // In particular read all the comments there carefully as there are a 
        // lot of red herrings where the question is answered based on useing
        // the photo roll.  Because of all these issues, I opted to get the 
        // location direct from the GPS rather than the image rather.
        
        self.imageDetails = "\(currentLocation.longitude) : \(currentLocation.latitude)"
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

    func enableSaveButton() {
        self.saveButton.isEnabled = true
        self.saveButton.backgroundColor = self.captureImageButton.backgroundColor
    }
    
    func disableSaveButton() {
        self.saveButton.isEnabled = false
        self.saveButton.backgroundColor = .gray    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        disableSaveButton()
        // configuration for things relating to location manager.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    @IBAction func unwindToRed(unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        self.currentLocation = location.coordinate
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ImageDetails") {
            // first downcast the destination controller to an ImageDetails controller
            // so that we can access its members
            let controller = segue.destination as! ImageDetailsViewController
            controller.location = self.currentLocation
        }
        //segue.destination.imageDetailsLabel.text = self.imageDetails
    }
}
