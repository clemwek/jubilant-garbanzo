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
      "Authorization": "Bearer \(String(describing: defaults.string(forKey: "token")))",
      "Accept": "application/json",
      "Content-Type": "application/json"
    ]
    
    let originText = originPicker.text?.split(separator: "_")[1]
    let DestText = destination.text?.split(separator: "-")[1]
    let url = "/operations/schedules/\(String(describing: originText))/\(String(describing: DestText))/2019-11-01"
    NetworkClient.standard.get(url: url,
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
