//
//  TMUtility.swift
//  TrailMapper
//
//  Created by Netwin on 09/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit

class TMUtility: NSObject {

    static var sharedInstance:TMUtility {
        struct Static  {
            static let instance:TMUtility = TMUtility()
        }
        return Static.instance
    }

    func saveImage(imagetoConvert image: UIImage, name imageName :String) -> String
    {
        let imageData: Data? = UIImageJPEGRepresentation(image, 0.8)
        let fileManager = FileManager.default
        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String? = (paths[0] as? String)
        let imagePath = documentsDirectory?.appending("/\(imageName)")
        fileManager.createFile(atPath: imagePath!, contents: imageData, attributes: nil)
        return imagePath!
    }

}
