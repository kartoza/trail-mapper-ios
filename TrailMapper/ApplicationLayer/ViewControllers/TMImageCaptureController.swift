//
//  ImageCaptureController.swift
//  TakeAPhoto
//
//  Created by Tim Sutton on 2017/08/16.
//  Copyright © 2017 Tim Sutton. All rights reserved.
//

import UIKit
import Photos

class TMImageCaptureController:
    UIViewController,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    CLLocationManagerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    let locationManager = CLLocationManager() // for getting GPS coords
    var currentLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()// for storing last coord
    
    @IBAction func buttonPressed(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        imagePickerController.allowsEditing = false
        disableSaveButton()
        self.present(imagePickerController, animated: true)
        {
            // after it is complete
        }
    }
    
    @IBAction func savePhoto(_ sender: AnyObject) {
        // logic from https://stackoverflow.com/q/45277034
        let imagePNGRepresentation = UIImagePNGRepresentation(image.image!)
        let compresedImage = UIImage(data: imagePNGRepresentation!)
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation])
    {
        // I searched long and hard to get the location direct from the image.
        // You can get it from a photo roll image but not one direclty captured
        // by using the camera. See https://stackoverflow.com/a/42888731
        // In particular read all the comments there carefully as there are a
        // lot of red herrings where the question is answered based on useing
        // the photo roll. Because of all these issues, I opted to get the
        // location direct from the GPS rather than the image
        let location = locations[0]
        self.currentLocationCoordinate = location.coordinate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ImageDetails") {
            // first downcast the destination controller to an ImageDetails controller
            // so that we can access its members
            let controller = segue.destination as! TMImageDetailsViewController
            controller.location = self.currentLocationCoordinate
        }
        //segue.destination.imageDetailsLabel.text = self.imageDetails
    }
}
