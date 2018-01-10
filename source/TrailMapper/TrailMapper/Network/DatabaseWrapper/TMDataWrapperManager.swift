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
            trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_MAPPER_TABLE)", type: "SELECT")
        }else {
            trailsArray = SCIDatabaseDAO.shared().executeQuery("Select * from \(TMConstants.kTRAIL_MAPPER_TABLE) WHERE id='\(trailId)'", type: "SELECT")
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
        SCIDatabaseDAO.shared().executeInsertQuery("INSERT INTO \(TMConstants.kTRAIL_MAPPER_TABLE)(pkuid,id, name,notes,image,guid,colour,offset) VALUES ('\(trailModel.pkuid ?? 0)','\(trailModel.id!)','\(trailModel.name ?? "")','\(trailModel.notes ?? "NA")','\(trailModel.image ?? "NA")','\(trailModel.guid ?? "")','\(trailModel.colour ?? "")','\(trailModel.offset ?? 0)')")
    }
    
}
