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
  var airPortResponse: AirportResponse? = nil
  let picker = UIPickerView()
  var activeTextField: UITextField?
  
  
  @IBOutlet weak var originPicker: UITextField!
  @IBOutlet weak var destination: UITextField!
  
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
          return completion(false, data)
        }
        return completion(true, data)
      }
    })
    dataTask.resume()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let jsonDecoder = JSONDecoder()
    guard let path = Bundle.main.path(forResource: "Aiports", ofType: "json") else {
      fatalError("Aiports file not found")
    }
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      airPortResponse = try jsonDecoder.decode(AirportResponse.self, from: data)
    }catch{
      print("could not load json object: \(error.localizedDescription)")
    }
    
    setPickerView()
  }
  
  func setPickerView() {
    self.picker.delegate = self
    self.picker.dataSource = self
    originPicker.inputView = picker
    destination.inputView = picker
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
  }
}

extension ScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return airPortResponse?.airportResource.airports.airport.count ?? 1
  }
  
  func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    guard let value = airPortResponse?.airportResource.airports.airport[row]  else { return "no value" }
    return (value.timeZoneID + " - " + value.airportCode)
  }
  
  func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard let value = airPortResponse?.airportResource.airports.airport[row]  else { return }
    if activeTextField == originPicker {
      originPicker.text = (value.timeZoneID + " - " + value.airportCode)
      originPicker.resignFirstResponder()
      self.activeTextField = nil
    } else {
      destination.text = (value.timeZoneID + " - " + value.airportCode)
      destination.resignFirstResponder()
      self.activeTextField = nil
    }
  }
}
