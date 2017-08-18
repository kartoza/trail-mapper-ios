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
                      UIImagePickerControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageDetails: UILabel!
    
    @IBAction func buttonPressed(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerControllerSourceType.camera
        imageController.allowsEditing = false
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
        } else {
            // handle error
        }

        if let URL = info[UIImagePickerControllerMediaURL] as? URL {
            let opts = PHFetchOptions()
            opts.fetchLimit = 1
            let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
            let asset = assets[0]
            if asset == nil {
                imageDetails.text = "No image captured."
            }
            //location: CLLocation = asset.location
            //coordinate: CLLocationCoordinate2D = location.coordinate
            //latitude = asset.location.coordinate.latitude
            //longitude = asset.location.coordinate.longitude()
            //imageDetails.text =  "Position: \(longitude), \(latitude)"
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

