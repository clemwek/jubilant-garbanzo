//
//  ScheduleViewController.swift
//  airline-list
//
//  Created by Clement Wekesa on 16/06/2019.
//  Copyright © 2019 Clement Wekesa. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
  let defaults = UserDefaults.standard
  
  @IBAction func getSchedule(_ sender: Any) {
    let header = [
      "Authorization": "Bearer \(defaults.string(forKey: "token"))",
      "Accept": "application/json",
      "Content-Type": "application/json"
    ]
    print(header)
    get(url: "/operations/schedules/FRA/JFK/2019-11-01",
        headers: header) { (status, data) -> (Void) in
          print("This is the data: \(data)")
          do {
          let formattedData = try JSONSerialization.jsonObject(with: data!, options: [])
          print("formattedData: \(formattedData)")
          } catch let error {
            print("Error passing JSON: \(error)")
          }
    }
  }
  
  func get(url: String,
           headers: [String: String],
           completion: @escaping (_ succes: Bool, _ data: Data?) -> (Void)) {
    
    let baseURL = "https://api.lufthansa.com/v1"
    let relativeURL = URL(string: baseURL + url)
    
    let request = NSMutableURLRequest(url: relativeURL!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 100.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
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
          return completion(false, data)
        }
        return completion(true, data)
      }
    })
    dataTask.resume()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
