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

    var recordingTrailSectionGUID = ""
    var recordingUpdateTimer = Timer()

    // Image save function to store in documents directory
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

    // Local sync check function for trails data is sync with server or not
    func syncLocalTrailDetailsWithServer() {
        let dataManagerWrapper = TMDataWrapperManager()

        dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
            if (responseArray?.count)! > 0 {
                for trailModel in responseArray! {
                    let trail = trailModel as! TMTrails
                    if (Bool(trail.synchronised ?? "0") == false)   {
                        print(" Trails : \(String(describing: trail.name!)) needs to sync with server")
                        self.callToSaveTrailOnServer(trail: trail)
                    }
                }
            }
        }
        dataManagerWrapper.callToGetTrailsFromDB(trailGUID: "")
    }

    // Call to save trails  data to server
    func callToSaveTrailOnServer(trail:TMTrails){

        let reqstParams:[String:Any] = ["":""]

        TMWebServiceWrapper.getTrailsFromServer(KMethodType:.kTypePOST, APIName: TMConstants.kWS_GET_TRAILS, Parameters: reqstParams, onSuccess: { (response) in

            // If we get True in response then update the local trails database record with true status for synchronised field.
            TMDataWrapperManager.sharedInstance.saveSyncStatusForTrails(trailGUID: trail.guid ?? "")

        }) { (error) in

        }
    }

    // Local sync check function for trail section data is sync with server or not
    func syncLocalTrailSectionDetailsWithServer() {
        let dataManagerWrapper = TMDataWrapperManager()

        dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
            if (responseArray?.count)! > 0 {
                for trailSectionModel in responseArray! {
                    let trailSection = trailSectionModel as! TMTrailSections
                    if (Bool(trailSection.synchronised ?? "0") == false)  {
                        print(" Trail Section : \(String(describing: trailSection.name!)) needs to sync with server")
                        self.callToSaveTrailSectionsOnServer(trailSection: trailSection)
                    }
                }
            }
        }
        dataManagerWrapper.callToGetTrailSectionFromDB(trailSectionGUID: "")
    }

    // Call to save trail section data to server
    func callToSaveTrailSectionsOnServer(trailSection:TMTrailSections){
        let reqstParams:[String:Any] = ["":""]

        TMWebServiceWrapper.getTrailsFromServer(KMethodType:.kTypePOST, APIName: TMConstants.kWS_GET_TRAILS, Parameters: reqstParams, onSuccess: { (response) in

            // If we get True in response then update the local trail section database record with true status for synchronised field.
            TMDataWrapperManager.sharedInstance.saveSyncStatusForTrailSection(trailSectionGUID: trailSection.guid ?? "")

        }) { (error) in

        }
    }

    // Check for any trail section is in recording state or not.
    func checkForRecordringStatus() {
        let dataManagerWrapper = TMDataWrapperManager()

        dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
            if (responseArray?.count)! > 0 {
                for trailSectionModel in responseArray! {
                    let trailSection = trailSectionModel as! TMTrailSections
                    // Check here the trail section has end time or not
                    // if end time not there then it will consider as trail section recording is going on
                    if trailSection.dateTimeEnd == nil {
                        TMUtility.sharedInstance.recordingTrailSectionGUID = trailSection.guid ?? ""
                        TMLocationManager.sharedInstance.startTrailingSectionUpdates()
                        //Start saving trail section recording locations to local db
                        self.saveRecordingTrailSectionUpdatesToLocalDB()
                    }
                }
            }
        }
        dataManagerWrapper.callToGetTrailSectionFromDB(trailSectionGUID: "")
    }

    // Start saving recordin trail section points for particular time interval
    func saveRecordingTrailSectionUpdatesToLocalDB() {
        if TMUtility.sharedInstance.recordingTrailSectionGUID != "" {
            if !recordingUpdateTimer.isValid {
                recordingUpdateTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(TMConstants.cTrailSectionLocUpdateTimer), repeats: true, block: { (timer) in
                    self.saveTrailLocationInBackgroundTask(timer: timer)
                })
            }
        }
    }

    // Stop saving recordin trail section points to local DB
    func stopTrailRecordingUpdatedToLocalDB(){
        if recordingUpdateTimer.isValid {
            recordingUpdateTimer.invalidate()
        }
    }

    // Saving trail sections locations points in background process.
    func saveTrailLocationInBackgroundTask(timer:Timer) {
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {

            // Check whether current & previous points are same or not
            if !TMLocationManager.sharedInstance.previousRecordedTrailSectionLocation.isEqual(TMLocationManager.sharedInstance.latestLocationCoordinate) {
                // Save location to local DB
                let locationStr = "\(TMLocationManager.sharedInstance.latestLocationCoordinate.longitude) \(TMLocationManager.sharedInstance.latestLocationCoordinate.latitude)"
                //Call TMDataWrapperManager function to save current recording trail section location
                TMDataWrapperManager.sharedInstance.saveLocationUpdateForTrailSection(locationString: locationStr, trailSectionGUID: TMUtility.sharedInstance.recordingTrailSectionGUID)
            }

            DispatchQueue.main.async {
                print("update some UI if needed")
            }
        }
    }

    // Get the formatted linestring from trailsections geom
    func getLineStringFromTrailSectionGeom(lineString:String)-> String{
        var returnString = lineString

        returnString = lineString.replace(target: "LINESTRING(", withString: "").replace(target: ")", withString: "")

        return returnString
    }
}

extension String {
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

