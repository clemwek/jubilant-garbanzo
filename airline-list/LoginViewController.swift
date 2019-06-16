//
//  ViewController.swift
//  airline-list
//
//  Created by Clement Wekesa on 13/06/2019.
//  Copyright © 2019 Clement Wekesa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  let defaults = UserDefaults.standard
  let baseURL = URL(string: "https://api.lufthansa.com/v1")

  @IBAction func login(_ sender: Any) {
    let header = ["Content-Type": "application/x-www-form-urlencoded"]

    NetworkClient.standard.post(url: "/oauth/token",
                                headers: header,
                                data: nil) { status, data in
      if status {
        if let data = data {
          print("Test data: \(data)", "type of: \(type(of: data))")
          let credDecoder = JSONDecoder()
          do {
            let credResults = try credDecoder.decode(Credencials.self, from: data)
            self.defaults.set(credResults.accessToken, forKey: "token")
            DispatchQueue.main.async {
              self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
          } catch {
            print("Failed to decode!")
          }
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

