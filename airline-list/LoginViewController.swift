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
        if let data = data as? [String: String],
          let token = data["access_token"] {
          self.defaults.set(token, forKey: "token")   
        }
        DispatchQueue.main.async {
          self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

