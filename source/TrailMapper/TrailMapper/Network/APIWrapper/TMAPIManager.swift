//
//  TMAPIManager.swift
//  TrailMapper
//
//  Created by Tim Sutton on 2018/01/08.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration

enum kMethodType : Int {
    case kTypeGET = 0
    case kTypePOST
    case kTypeFORM_POST
}

class TMAPIManager: NSObject {

    typealias OnSuccessCompletionHandler = (_ receivedString: Any) -> Void
    typealias OnFailureCompletionHandler = (_ error: Error?) -> Void

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

    // Generalise function to call all types of API methods
    static func callAPI(KMethodType method:kMethodType ,APIName strAPI: String,Parameters parameters:
        Parameters, onSuccess success: @escaping OnSuccessCompletionHandler, onFailure failure:
        @escaping OnFailureCompletionHandler) {

        if TMAPIManager.sharedInstance.startNetworkReachabilityObserver(){

            let strAbsoluteURL: String = "\(strAPI)".trimmingCharacters(in: .whitespaces)
            var requestMethod : HTTPMethod

            // Get the method types
            switch method {
            case .kTypeGET:
                requestMethod = .get
            case .kTypePOST:
                requestMethod = .post
            case .kTypeFORM_POST:
                requestMethod = .post
            }

            //For debug purpose
            print("\(NSDate()) Request : \(strAbsoluteURL)\nParameters: \n \(parameters)")

            //Show activity indicator
            if method == .kTypeFORM_POST{
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        for strRecord in parameters {
                            if FileManager.default.fileExists(atPath: strRecord.value as! String) {
                                let url: String? = strRecord.value as? String
                                let parts: [Any]? = url?.components(separatedBy: "/")
                                let filename: String? = parts?.last as? String
                                if ((filename?.range(of: ".jpg")?.lowerBound) != nil) {
                                    multipartFormData.append(FileManager.default.contents(atPath:
                                        strRecord.value as! String)!, withName: strRecord.key, fileName:
                                        "\(filename ?? "" ).jpg", mimeType: "image/jpeg")
                                }
                                else {
                                    //for Video data
                                }
                            }
                            else {
                                multipartFormData.append((strRecord.value as AnyObject).data(using:
                                    String.Encoding.utf8.rawValue)!, withName: strRecord.key)
                            }
                        }
                },
                    to: strAbsoluteURL,
                    encodingCompletion: { encodingResult in

                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.validate(statusCode: 200..<201)
                            upload.responseJSON { response in

                                switch response.result {
                                case .success:
                                    //Hide any activity indicator here
                                    success(response.result.value!)
                                case .failure(let error):
                                    print(error)
                                    //Hide any activity indicator here
                                    failure(error)
                                }
                            }
                        case .failure(let encodingError):
                            //Hide any activity indicator here
                            failure(encodingError)
                        }
                }
                )

            } else{

                Alamofire.request(strAbsoluteURL, method: requestMethod, parameters: parameters, encoding: JSONEncoding.default)
                    .validate(statusCode: 200..<201).responseJSON { response in

                        //Hide any activity indicator here
                        switch response.result {
                        case .success:
                            success(response.result.value!)
                        case .failure(let error):
                            print(error)

                            if let httpStatusCode = response.response?.statusCode {
                                if  httpStatusCode >= 400 && httpStatusCode < 500 {
                                    print("client side errors 400-500")

                                }else if httpStatusCode >= 500 && httpStatusCode < 600{
                                    print("server side errors")
                                }
                            }
                            failure(error)
                        }

                }
            }
        }
    }

    static func downloadFile(downloadURL strAPI: String, onSuccess success: @escaping OnSuccessCompletionHandler, onFailure failure:
        @escaping OnFailureCompletionHandler,onDownloadProgress progress: @escaping OnSuccessCompletionHandler ) {

        let utilityQueue = DispatchQueue.global(qos: .utility)

        Alamofire.download(strAPI)
            .downloadProgress(queue: utilityQueue) { progressCompleted in
                print("Download Progress: \(progressCompleted.fractionCompleted)")
                progress(progressCompleted)
            }
            .responseData { response in

                let httpStatusCode = response.response?.statusCode
                switch response.result {
                case .success:
                    success(response.result.value!)
                case .failure(let error):
                    print(error)

                    if  httpStatusCode! >= 400 && httpStatusCode! < 500 {
                        print("client side errors 400-500")

                    }else if httpStatusCode! >= 500 && httpStatusCode! < 600{
                        print("server side errors")

                    }
                    failure(error)
                }
        }
    }


    ///network connection observer
    func startNetworkReachabilityObserver() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        if(isReachable == false && needsConnection == false){
            AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message: TMConstants.kNoInternetConnection, PositiveTitle:TMConstants.kAlertTypeOK)
        }
        return (isReachable && !needsConnection)
    }
}
