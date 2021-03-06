//
//  APIClient.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import Alamofire
import PromiseKit
import JASON

enum APIClientError: ErrorType {
    case RequestFailed
}

class APIClient {
    
    private static let baseURL = "https://api.worldweatheronline.com/premium/v1"
    private static let APIKey = "7fe91fdbf82243deb8fe96908711c"
    
    /// Enables request logging
    static var loggingEnabled = false
    
    static let defaultManager: Alamofire.Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()

        // Uncomment this for ignoring HTTP cache
        //configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
        
        return Alamofire.Manager(configuration: configuration)
    }()
    
    /**
     Sends request and serialize response into JSON, may throw APIClientError
     
     @param method Used to specify the way in which a set of parameters are applied to a URL request.
     @param URLString URL address that is appended to baseURL
     @param parameters Parameters, default `nil`
     @param encoding Parameter encoding, default `.URL`
     @param headers HTTP headers, default `nil`
     
     @return Promise with serialized JSON
     */
    
    class func requestJSON(method: Alamofire.Method, URLString: String, parameters: [String : AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String : String]? = nil) -> Promise<JSON> {
        
        return Promise { success, reject in
            
            var params: [String: AnyObject] = parameters ?? [:]
            
            params["key"] = APIKey
            params["format"] = "json"
            
            let request = APIClient.defaultManager.request(method, APIClient.baseURL + URLString, parameters: params, encoding: encoding, headers: headers)
            if loggingEnabled {
                print(request)
                print("Params: \(parameters)")
            }
            
            request.responseJSON { (response) -> Void in
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    
                    if response.result.error != nil {
                        if loggingEnabled {
                            print(response)
                            print("Params: \(response.result.error!)")
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            reject(APIClientError.RequestFailed)
                        }
                        
                        return
                    }
                    
                    if let statusCode = response.response?.statusCode where statusCode >= 300 {
                        
                        if loggingEnabled {
                            print("Request failed with status code: \(statusCode)")
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            reject(APIClientError.RequestFailed)
                        }
                        return
                    }
                    
                    if let jsonData = response.result.value {
                        
                        if loggingEnabled {
                            print(jsonData)
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            success(JSON(jsonData))
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            reject(APIClientError.RequestFailed)
                        }
                    }
                }
            }
            
        }
    }
}
