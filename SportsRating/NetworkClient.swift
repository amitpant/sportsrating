//
//  NetworkClient.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 01/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

public final class NetworkClient{
    
    private struct Keys{
        static let status = "status"
        static let message = "message"
        static let data = "data"
    }
    
    //MARK: Instance Properties
    internal let baseURL:URL
    internal let session = URLSession.shared
    
    //MARK: Class Constructors
    public static let shared:NetworkClient = {
        let file = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        let urlString = dictionary["service_url"] as! String//live_service_url
        let url = URL(string: urlString)!
        return NetworkClient(baseURL: url)
    }()
    
    public init(baseURL:URL){
        self.baseURL = baseURL
    }
    
    func callAPI(params: [String:Any]?,
                                 success _success: @escaping([String:Any])-> Void,
                                 failure _failure: @escaping(NetworkError)-> Void) {
        let success: ([String:Any])-> Void = { data in
            DispatchQueue.main.async {
                _success(data)
            }
        }
        
        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async {
                _failure(error)
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var request = URLRequest(url: baseURL)
        
        
        if let params = params {
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params , options: [])
            print("\(params)")
        }
        else{
            request.httpMethod = "GET"
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data,
                let jsonObject = try?  JSONSerialization.jsonObject(with: data),
                let jsonResult = jsonObject as? [String: Any]
                else{
                    if let error = error{
                        failure(NetworkError(error: error))
                    }
                    else{
                        failure(NetworkError(response: response))
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
            }
            success(jsonResult)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }
    
    func uploadImage(apiname: String,
                     params: [String:Any]?,
                     imageData:Data,
                     success _success: @escaping([String:Any])-> Void,
                     failure _failure: @escaping(NetworkError)-> Void)
    {
        
        let success: ([String:Any])-> Void = { data in
            DispatchQueue.main.async {
                _success(data)
            }
        }
        
        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async {
                _failure(error)
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let relativeURL = URL(string: apiname, relativeTo: baseURL) else{return}
        var request  = URLRequest(url: relativeURL)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: params,
                                boundary: boundary,
                                data:imageData,
                                mimeType: "image/jpg",
                                filename: "hello.jpg")
      
        
        let task = session.dataTask(with: request) { (data, response, error) in
           
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data,
                let jsonObject = try?  JSONSerialization.jsonObject(with: data),
                let jsonResult = jsonObject as? [String: Any]
                else{
                    if let error = error{
                        failure(NetworkError(error: error))
                    }
                    else{
                        failure(NetworkError(response: response))
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
            }
            print(jsonResult)
            success(jsonResult)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
        
    }
    
    private func createBody(parameters: [String: Any]?,
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    private func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}

