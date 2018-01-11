//
//  TMDataWrapperManager.swift
//  TrailMapper
//
//  Created by Netwin on 09/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit

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
    func callToGetTrailsFromDB(trailId:String)
    {
        var trailsArray = NSMutableArray.init()
        let trailsModelArray = NSMutableArray.init()
        
        if trailId == "" {
            trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_TABLE)", type: "SELECT")
        }else {
            trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_TABLE) WHERE id='\(trailId)'", type: "SELECT")
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
     // Function Purpose : To save the trails onlocal storage
     //Params
     * trailModel : Pass the trail model
     // Response :
     **/

    func saveTrailToLocalDatabase(trailModel:TMTrails)
    {
        let trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_TABLE) WHERE guid='\(String(describing: trailModel.guid ?? ""))'", type: "SELECT")

        if (trailsArray?.count ?? 0) > 0 {
            SCIDatabaseDAO.shared().executeUpdateQuery("UPDATE \(TMConstants.kTRAIL_TABLE) set id = '\(trailModel.id!)',name = '\(trailModel.name ?? "")',notes = 'No Notes',image_path = '\(trailModel.image ?? "")',colour = '\(trailModel.colour ?? "")',offset = '\(trailModel.offset ?? 0)',geometry = '\(trailModel.geom ?? "")' where guid = '\(trailModel.guid!)'") //(trailModel.notes!) Do later
        }else {
            let dbOperationStatus = SCIDatabaseDAO.shared().executeInsertQuery("INSERT INTO \(TMConstants.kTRAIL_TABLE)(id, name,notes,image_path,guid,colour,offset,geometry) VALUES ('\(trailModel.id!)','\(trailModel.name ?? "")','No Notes','\(trailModel.image ?? "NA")','\(trailModel.guid ?? "")','\(trailModel.colour ?? "")','\(trailModel.offset ?? 0)','\(trailModel.geom ?? "")')") // ,'\(trailModel.notes ?? "NA")' Do later

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
    
    func saveTrailSectionsToLocalDatabase(trailSectionModel:TMTrailSections)
    {

        //This will be dependant on JSON response of TrailSection API

        //        let trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_SECTION_TABLE) WHERE guid='\(String(describing: trailSectionModel.guid ?? ""))'", type: "SELECT")
        //
        //        if (trailsArray?.count ?? 0) > 0 {
        //            SCIDatabaseDAO.shared().executeUpdateQuery("UPDATE \(TMConstants.kTRAIL_SECTION_TABLE) set id = '\(trailSectionModel.id!)',name = '\(trailSectionModel.name ?? "")',notes = 'No Notes',image_path = '\(trailSectionModel.image ?? "")',colour = '\(trailModel.colour ?? "")',offset = '\(trailModel.offset ?? 0)',geometry = '\(trailModel.geom ?? "")' where id = '\(trailModel.guid!)'") //(trailModel.notes!) Do later
        //        }else {
        //            let dbOperationStatus = SCIDatabaseDAO.shared().executeInsertQuery("INSERT INTO \(TMConstants.kTRAIL_SECTION_TABLE)(id, name,notes,image_path,guid,colour,offset,geometry) VALUES ('\(trailModel.id!)','\(trailModel.name ?? "")','No Notes','\(trailModel.image ?? "NA")','\(trailModel.guid ?? "")','\(trailModel.colour ?? "")','\(trailModel.offset ?? 0)','\(trailModel.geom ?? "")')") // ,'\(trailModel.notes ?? "NA")' Do later
        //
        //            if let webServiceWrapperBlockHandler = self.SDDataWrapperBlockHandler
        //            {
        //                if dbOperationStatus {
        //                    webServiceWrapperBlockHandler([], nil,nil)
        //                }else {
        //                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Operation failed"])
        //                    webServiceWrapperBlockHandler([], nil,error)
        //                }
        //            }
        //        }
    }
    
}
