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
    
    private static let baseURL = "https://api.worldweatheronline.com/free/v2"
    private static let APIKey = "f4530bb95f0ab0edf756bcfdcb8ef"
    
    /// Enables request logging
    static var loggingEnabled = false
    
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
            
            let request = Alamofire.request(method, APIClient.baseURL + URLString, parameters: params, encoding: encoding, headers: headers)
            if loggingEnabled {
                print(request)
                print("Params: \(parameters)")
            }
            
            request.responseJSON { (response) -> Void in
                
                if response.result.error != nil {
                    reject(APIClientError.RequestFailed)
                    return
                }
                
                if let statusCode = response.response?.statusCode where statusCode >= 300 {
                    
                    if loggingEnabled {
                        print("Request failed with status code: \(statusCode)")
                    }
                    reject(APIClientError.RequestFailed)
                    return
                }
                
                if let jsonData = response.result.value {
                    
                    if loggingEnabled {
                        print(jsonData)
                    }
                    success(JSON(jsonData))
                } else {
                    reject(APIClientError.RequestFailed)
                }
            }
            
        }
    }
}
