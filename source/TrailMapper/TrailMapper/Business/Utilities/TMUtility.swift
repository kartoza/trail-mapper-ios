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

    func syncLocalDataBaseWithServer() {
        let dataManagerWrapper = TMDataWrapperManager()

        dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
            if (responseArray?.count)! > 0 {
                for trailModel in responseArray! {
                    let trail = trailModel as! TMTrails
                    if (trail.guid == nil)  {
                        print(" Trails : \(String(describing: trail.name!)) needs to sync with server")
                        self.callToSaveTrailOnServer(trail: trail)
                    }
                }
            }
        }
        dataManagerWrapper.callToGetTrailsFromDB(trailId: "")
    }

    func callToSaveTrailOnServer(trail:TMTrails){

        let reqstParams:[String:Any] = ["":""]

        TMWebServiceWrapper.getTrailsFromServer(KMethodType:.kTypePOST, APIName: TMConstants.kWS_GET_TRAILS, Parameters: reqstParams, onSuccess: { (response) in

            // If we get GUID in response then update the local database record with Guid.
            //TMDataWrapperManager.sharedInstance.saveTrailToLocalDatabase(trailModel: trail)


        }) { (error) in

        }
    }

}
