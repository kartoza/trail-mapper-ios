//
//  TMDataWrapperManager.swift
//  TrailMapper
//
//  Created by Netwin on 09/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit
import CoreLocation

class TMDataWrapperManager: NSObject {

    var SDDataWrapperBlockHandler: ((NSMutableArray?, NSDictionary?,NSError?) -> Void)? = nil

    static var sharedInstance:TMDataWrapperManager {
        struct Static  {
            static let instance:TMDataWrapperManager = TMDataWrapperManager()
        }
        return Static.instance
    }

    /**
     // Function Purpose : To get the trails from local storage
     //Params
     * trailId : Pass the trail identifer ID
     // Response :  Get response (trails array/dictionary) through block handler function.
     **/
    func callToGetTrailsFromDB(trailGUID:String)
    {
        var trailsArray = NSMutableArray.init()
        let trailsModelArray = NSMutableArray.init()
        
        if trailGUID == "" {
            trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_TABLE)", type: "SELECT")
        }else {
            trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_TABLE) WHERE guid='\(trailGUID)'", type: "SELECT")
        }

        for trails in trailsArray {
            let trailModel = TMTrails.init(object: trails)
            trailsModelArray.addObjects(from: [trailModel])
        }

        if let webServiceWrapperBlockHandler = self.SDDataWrapperBlockHandler
        {
            webServiceWrapperBlockHandler(trailsModelArray, nil,nil)
        }
    }

    /**
     // Function Purpose : To save the trails on local storage
     //Params
     * trailModel : Pass the trail model
     // Response :
     **/

    func saveTrailToLocalDatabase(trailModel:TMTrails)
    {
        let trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_TABLE) WHERE guid='\(String(describing: trailModel.guid ?? ""))'", type: "SELECT")

        if (trailsArray?.count ?? 0) > 0 {
            SCIDatabaseDAO.shared().executeUpdateQuery("UPDATE \(TMConstants.kTRAIL_TABLE) set name = '\(trailModel.name ?? "")',notes = 'No Notes',image_path = '\(trailModel.image ?? "")',colour = '\(trailModel.colour ?? "")',offset = '\(trailModel.offset ?? 0)',geometry = '\(trailModel.geom ?? "")' where guid = '\(trailModel.guid!)'") //(trailModel.notes!) Do later
        }else {
            let dbOperationStatus = SCIDatabaseDAO.shared().executeInsertQuery("INSERT INTO \(TMConstants.kTRAIL_TABLE)(name,notes,image_path,guid,colour,offset,geometry) VALUES ('\(trailModel.name ?? "")','No Notes','\(trailModel.image ?? "NA")','\(trailModel.guid ?? "")','\(trailModel.colour ?? "")','\(trailModel.offset ?? 0)','\(trailModel.geom ?? "")')") // ,'\(trailModel.notes ?? "NA")' Do later

            if let webServiceWrapperBlockHandler = self.SDDataWrapperBlockHandler
            {
                if dbOperationStatus {
                    webServiceWrapperBlockHandler([], nil,nil)
                }else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Operation failed"])
                    webServiceWrapperBlockHandler([], nil,error)
                }
            }
        }
    }

    /**
     // Function Purpose : To save the trails with sectins on local storage
     //Params
     * trailGUID : Pass the trail GUID
     * trailSectionGUID : Pass the trail section GUID
     // Response :
     **/
    func saveTrailWithSectionToLocalDatabase(trailGUID:String,trailSectionGUID:String)
    {
        let trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_WITH_SECTIONS_TABLE) WHERE trail_guid='\(String(describing: trailGUID))' AND trail_section_guid='\(String(describing: trailSectionGUID))'", type: "SELECT")

        if (trailsArray?.count ?? 0) > 0 {
            // no update needed
        }else {
            SCIDatabaseDAO.shared().executeInsertQuery("INSERT INTO \(TMConstants.kTRAIL_WITH_SECTIONS_TABLE)(trail_guid,trail_section_guid) VALUES ('\(trailGUID)','\(trailSectionGUID)')") // ,'\(trailModel.notes ?? "NA")' Do later
        }
    }

    /**
     // Function Purpose : To get the trail sections from local storage
     //Params
     * trailSectionGUID : Pass the trail GUID
     // Response :  Get response (trail section array/dictionary) through block handler function.
     **/
    func callToGetTrailSectionFromDB(trailSectionGUID:String)
    {
        var trailSectionArray = NSMutableArray.init()
        let trailSectionModelArray = NSMutableArray.init()

        if trailSectionGUID == "" {
            trailSectionArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_SECTION_TABLE)", type: "SELECT")
        }else {
            trailSectionArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_SECTION_TABLE) WHERE guid='\(trailSectionGUID)'", type: "SELECT")
        }

        for trailSection in trailSectionArray {
            let trailSectionModel = TMTrailSections.init(object: trailSection)
            trailSectionModelArray.addObjects(from: [trailSectionModel])
        }

        if let webServiceWrapperBlockHandler = self.SDDataWrapperBlockHandler
        {
            webServiceWrapperBlockHandler(trailSectionModelArray, nil,nil)
        }
    }

    /**
     // Function Purpose : To save the trail Section on local storage
     //Params
     * trailSectionModel : Pass the trail section model
     // Response :
     **/
    func saveTrailSectionsToLocalDatabase(trailSectionModel:TMTrailSections)
    {
        //This will be dependant on JSON response of TrailSection API

        let trailsSectionArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_SECTION_TABLE) WHERE guid='\(String(describing: trailSectionModel.guid ?? ""))'", type: "SELECT")

        if (trailsSectionArray?.count ?? 0) > 0 {
            SCIDatabaseDAO.shared().executeUpdateQuery("UPDATE \(TMConstants.kTRAIL_SECTION_TABLE) set name = '\(trailSectionModel.name ?? "")',notes = 'No Notes',image = '\(trailSectionModel.imagePath ?? "")',offset = '\(trailSectionModel.offset ?? 0)',geom = '\(trailSectionModel.geom ?? "")' where guid = '\(trailSectionModel.guid!)'") //(trailModel.notes!) Do later
        }else {
            let dbOperationStatus = SCIDatabaseDAO.shared().executeInsertQuery("INSERT INTO \(TMConstants.kTRAIL_SECTION_TABLE)(name,notes,image,guid,offset,geom,grade_guid,date_time_start) VALUES ('\(trailSectionModel.name ?? "")','No Notes','\(trailSectionModel.imagePath ?? "NA")','\(trailSectionModel.guid ?? "")','\(trailSectionModel.offset ?? 0)','\(trailSectionModel.geom ?? "")','\("Grade_GUID")','\(trailSectionModel.dateTimeStart ?? "")')") // ,'\(trailModel.notes ?? "NA")' Do later

            if let webServiceWrapperBlockHandler = self.SDDataWrapperBlockHandler
            {
                if dbOperationStatus {
                    webServiceWrapperBlockHandler([], nil,nil)
                }else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Operation failed"])
                    webServiceWrapperBlockHandler([], nil,error)
                }
            }
        }
    }

    // Make status of trail section as comlete by setting timestamp value to date_time_end
    func saveCompleteStatusForTrailSection(trailSectionGUID:String) {
        let endTimeStamp = Double(NSDate().timeIntervalSince1970 * 1000)
        SCIDatabaseDAO.shared().executeUpdateQuery("UPDATE \(TMConstants.kTRAIL_SECTION_TABLE) set date_time_end = '\(endTimeStamp)' where guid = '\(trailSectionGUID)'")
    }

    //Save location coming from TMLocationManager against recording trail section GUID
    func saveLocationUpdateForTrailSection(locationString:String,trailSectionGUID:String) {
        let trailsSectionArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_SECTION_TABLE) WHERE guid='\(String(describing: trailSectionGUID))'", type: "SELECT")

        if (trailsSectionArray?.count ?? 0) > 0 {
            let trailSection = trailsSectionArray?.object(at: 0)
            let trailSectionModel = TMTrailSections.init(object: trailSection as Any)
            var geometryLineString = TMUtility.sharedInstance.getLineStringFromTrailSectionGeom(lineString: trailSectionModel.geom ?? "")
            geometryLineString = "LINESTRING(\(geometryLineString),\(locationString))"
            SCIDatabaseDAO.shared().executeUpdateQuery("UPDATE \(TMConstants.kTRAIL_SECTION_TABLE) set geom = '\(geometryLineString)' where guid = '\(trailSectionGUID)'")
        }
    }

    // Get the linestring co-ordinates for Trail Section
    func getTrailSectionLocationPointsFor(trailSectionGUID:String)->[CLLocationCoordinate2D] {
        var finalPoints = [CLLocationCoordinate2D]()

        let trailsSectionArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_SECTION_TABLE) WHERE guid='\(String(describing: trailSectionGUID))'", type: "SELECT")

        if (trailsSectionArray?.count ?? 0) > 0 {
            let trailSection = trailsSectionArray?.object(at: 0)
            let trailSectionModel = TMTrailSections.init(object: trailSection as Any)
            let geometryLineString = TMUtility.sharedInstance.getLineStringFromTrailSectionGeom(lineString: trailSectionModel.geom ?? "")

            let pointsStringArray = geometryLineString.components(separatedBy: ",")

            if pointsStringArray.count > 0 {
                for stringPoints in pointsStringArray {
                    let pointArray = stringPoints.components(separatedBy: " ")
                    if pointArray.count == 2 {
                        let actualPoint = CLLocationCoordinate2DMake(Double(pointArray[1])!,Double(pointArray[0])!);
                        finalPoints.append(actualPoint)
                    }
                }
            }
        }

        return finalPoints
    }


    func saveSyncStatusForTrails(trailGUID:String) {
        SCIDatabaseDAO.shared().executeUpdateQuery("UPDATE \(TMConstants.kTRAIL_TABLE) set synchronised = '\(true)' where guid = '\(trailGUID)'")
    }

    func saveSyncStatusForTrailSection(trailSectionGUID:String) {
        SCIDatabaseDAO.shared().executeUpdateQuery("UPDATE \(TMConstants.kTRAIL_SECTION_TABLE) set synchronised = '\(true)' where guid = '\(trailSectionGUID)'")
    }

}
