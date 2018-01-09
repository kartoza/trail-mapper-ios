//
//  TMConstants.swift
//  TrailMapper
//
//  Created by Netwin on 09/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit

class TMConstants: NSObject {

    static let kApplicationName                     =       "TrailMapper"
    static let kWsAppUrl                                =       "https:\\"

    static let SCREEN_SIZE: CGRect                =       UIScreen.main.bounds

    //AlertTitle Constants
    static let kAlertTypeOK                             =       "OK"
    static let kAlertTypeCancel                       =       "Cancel"
    static let kAlertTypeYES                            =       "YES"
    static let kAlertTypeNO                             =       "NO"
    static let kAlertHideCancel                       =       ""

    static let kNoInternetConnection              =       "No internet connection"

    // SCIDatabaseDAO will consist full resource path this sqlite file.

    static let TM_DATABASE_NAME               =       "TrailMapper.sqlite"
    static let kTRAIL_MAPPER_TABLE                            =        "trail"

}
