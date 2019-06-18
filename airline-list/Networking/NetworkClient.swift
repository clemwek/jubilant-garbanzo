//
//  NetworkClient.swift
//  airline-list
//
//  Created by Clement Wekesa on 14/06/2019.
//  Copyright © 2019 Clement Wekesa. All rights reserved.
//

import Foundation

class NetworkClient {
  static let standard = NetworkClient()
  
  let baseURL = "https://api.lufthansa.com/v1"
  let defaults = UserDefaults.standard
  
  private init() { }
  
  func get(url: String,
           headers: [String: String],
           data: [String: String]?,
           completion: @escaping (_ succes: Bool, _ data: Data?) -> (Void)) {
    
    let relativeURL = URL(string: baseURL + url)
    
    let postData = NSMutableData(data: "Authorization=Bearer \(defaults.string(forKey: "token"))&Accept=application/json&Content-Type=application/json".data(using: .utf8)!)
    let request = NSMutableURLRequest(url: relativeURL!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 100.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData as Data
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      if (error != nil) {
        print("Network error: \(error!)")
        return completion(false, nil)
      } else {
        guard
          let statusCode = (response as? HTTPURLResponse)?.statusCode
          else { return }
        if String(statusCode).first != "2" {
          return completion(false, nil)
        }
        return completion(true, data)
      }
    })
    dataTask.resume()
  }
  
  func post(url: String,
            headers: [String: String],
            data: [String: String]?,
            completion: @escaping (_ succes: Bool, _ data: Data?) -> (Void)) {
    
    let relativeURL = URL(string: baseURL + url)
    
    let postData = NSMutableData(data: "client_id=\(Constants.clientKey)&client_secret=\(Constants.clientSecret)&grant_type=\(Constants.grantType)".data(using: .utf8)!)
    let request = NSMutableURLRequest(url: relativeURL!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData as Data
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      if (error != nil) {
        print("Network error: \(error!)")
        return completion(false, nil)
      } else {
        guard
          let statusCode = (response as? HTTPURLResponse)?.statusCode
          else { return }
        if String(statusCode).first != "2" {
          return completion(false, nil)
        }
        return completion(true, data)
      }
    })
    dataTask.resume()
  }
}
