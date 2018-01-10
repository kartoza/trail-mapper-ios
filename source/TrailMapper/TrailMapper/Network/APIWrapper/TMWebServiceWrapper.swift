//
//  TMWebServiceWrapper.swift
//  TrailMapper
//
//  Created by Netwin on 10/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit

class TMWebServiceWrapper: NSObject {

    //Success & failure block handlers initlisation
    typealias OnSuccessCompletionHandler = (_ receivedString: Any) -> Void
    typealias OnFailureCompletionHandler = (_ error: Error?) -> Void

    // API call to fetch trails for server instance
    static func getTrailsFromServer(KMethodType method:kMethodType ,APIName strAPI: String,
                                    Parameters parameters: [String: Any] , onSuccess success:@escaping OnSuccessCompletionHandler , onFailure failure: @escaping OnFailureCompletionHandler) {

        TMAPIManager.callAPI(KMethodType: method, APIName: strAPI, Parameters: parameters, onSuccess: { responseData in
            let trailsModel = TMTrailsModel.init(object: responseData)
            success(trailsModel)
        }) { (error) in
            failure(error)
        }
    }

}
