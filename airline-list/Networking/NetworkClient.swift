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
  
  let baseURL = URL(string: "https://api.lufthansa.com/v1")
  let defaults = UserDefaults.standard
  
  private init() { }
  
  func get(url: String, query: [String: String]?, completion: @escaping (_ status: Bool, _ data: Any? ) -> ()) {
    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = true
    let session = URLSession(configuration: config)
    
    let relativeURL = URL(string: url, relativeTo: baseURL)
    guard
      let url = URLComponents(url: relativeURL!, resolvingAgainstBaseURL: true)?.url,
      let token = defaults.string(forKey: "token")
      else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let task = session.dataTask(with: request) { data, response, error in
      guard
        error == nil,
        let responseData = data
        else { return completion(false, nil) }
      
      do {
        guard
          let formattedData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any]
          else {
            completion(false, nil)
            print("Error trying to convert data to json")
            return
        }
        guard
          let statusCode = (response as? HTTPURLResponse)?.statusCode
          else { return }
        if String(statusCode).first == "2" {
          return completion(true, formattedData)
        }
        completion(false, nil)
      } catch {
        completion(false, nil)
      }
    }
    task.resume()
    
  }
  
  func post(url: String,
            headers: [String: String],
            data: [String: String]?,
            completion: @escaping (_ succes: Bool, _ data: Any?) -> (Void)) {
    
    let postData = NSMutableData(data: "client_id=\(Constants.clientKey)&client_secret=\(Constants.clientSecret)&grant_type=\(Constants.grantType)".data(using: .utf8)!)
    let request = NSMutableURLRequest(url: NSURL(string: "https://api.lufthansa.com/v1/oauth/token")! as URL,
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
        let httpResponse = response as? HTTPURLResponse
        print(httpResponse!)
        
        do {
          let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
          print(json)
          return completion(true, json)
        } catch {
          print("Json Error: \(error)")
          return completion(false, nil)
        }
        
      }
    })
    dataTask.resume()
  }
}
