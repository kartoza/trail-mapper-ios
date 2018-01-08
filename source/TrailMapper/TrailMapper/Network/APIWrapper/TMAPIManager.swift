//
//  TMAPIManager.swift
//  TrailMapper
//
//  Created by Tim Sutton on 2018/01/08.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit
import Alamofire

class TMAPIManager: NSObject {
    
    static var sharedInstance:TMAPIManager {
        struct Static {
            static let instance:TMAPIManager = TMAPIManager()
        }
        return Static.instance
    }
    
    
    func getTrails() {
        Alamofire.request("https://gist.github.com/timlinux/272bab60ffd2357921a1d2a8f5395eb2/raw/e0a5806e9860051b1c1c3495a18bcf3b0a52dd4c/trails.json").responseJSON { (response) in
            print("Print Trails API",response.result.value ?? "NO Response")
        }
    }
    
    func getTrail(trailId:Int) {
        Alamofire.request("https://gist.github.com/timlinux/272bab60ffd2357921a1d2a8f5395eb2/raw/63233f2ca980a5b9e6966eb7b1fe2dd501c74ec4/tail\(trailId).json").responseJSON { (response) in
            print("Print Trail API",response.result.value ?? "NO Response")
        }
    }
}
