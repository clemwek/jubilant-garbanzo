//
//  Credencials.swift
//  airline-list
//
//  Created by Clement Wekesa on 16/06/2019.
//  Copyright © 2019 Clement Wekesa. All rights reserved.
//

import Foundation

struct Credencials: Codable {
  let accessToken: String
  let tokenType: String
  let expiresIn: Int
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case expiresIn = "expires_in"
  }
}
