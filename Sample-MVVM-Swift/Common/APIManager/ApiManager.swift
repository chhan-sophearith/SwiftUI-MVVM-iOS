//
//  ApiManager.swift
//  Sample-MVVM-Swift
//
//  Created by Chhan Sophearith on 21/10/23.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

public typealias Parameters = [String: Any]
public typealias Success = (_ response: Data) -> Void
public typealias HTTPHeaders = [String: String]

class ApiManager {
    
    static let shared = ApiManager()

    func getHeader()-> HTTPHeaders {
        let headers: HTTPHeaders = [
           // "Authorization": "Bearer \(Session.shared.getHeaderToken())",
            "Content-Type": "application/json",
            "Authorize" : "4ee0d884634c0b04360c5d26060eb0dac61209c0db21d84aa9b315f1599e9a41",
            "Auth" :  "6213cbd30b40d782b27bcaf41f354fb8aa2353a9e59c66fba790febe9ab4cf44",
            "lang" : "en"
         ]
        return headers
    }
    
    func apiConnection<T: Codable>(url: String, method: HTTPMethod, param: Parameters?, res: @escaping (T) -> Void) {
        
        let strUrl = URL(string: ApiEndPoint.baseUrl.rawValue + url)
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.url = strUrl
        request.allHTTPHeaderFields = getHeader()
        request.httpMethod = method.rawValue
    
        // add headers
//        if headers == nil {
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        } else {
//            if let header = headers {
//                for (key, value) in header {
//                    request.setValue(value, forHTTPHeaderField: key)
//                }
//            }
//        }
        
        // add parameters
        do {
            if let param = param {
                request.httpBody = try JSONSerialization.data(withJSONObject: param , options:[])
            }
        } catch let error as NSError {
            print("error", error.localizedDescription)
        }
        
        let newRequest = request as URLRequest
       
        // request to api
        let task = URLSession.shared.dataTask(with: newRequest, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
               // Loading.shared.hideLoading()
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    Utilize.shared.debugerResult(urlRequest: newRequest, data: data, error: false)
                   
                    Utilize.shared.validateModel(model: T.self, data: data) { objectData in
                        res(objectData)
                    }
   
                } else {
                    Utilize.shared.debugerResult(urlRequest: newRequest, data: data, error: true)
                    print("error_code: \(httpResponse.statusCode)")
                }
            }
        })
        task.resume()
    }
}
