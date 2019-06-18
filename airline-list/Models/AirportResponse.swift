//
//  AirportResponse.swift
//  airline-list
//
//  Created by Clement Wekesa on 19/06/2019.
//  Copyright © 2019 Clement Wekesa. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AirportResponse: Codable {
  let airportResource: AirportResource
  
  enum CodingKeys: String, CodingKey {
    case airportResource = "AirportResource"
  }
}

// MARK: - AirportResource
struct AirportResource: Codable {
  let airports: Airports
  //    let meta: Meta
  
  enum CodingKeys: String, CodingKey {
    case airports = "Airports"
    //        case meta = "Meta"
  }
}

// MARK: - Airports
struct Airports: Codable {
  let airport: [Airport]
  
  enum CodingKeys: String, CodingKey {
    case airport = "Airport"
  }
}

// MARK: - Airport
struct Airport: Codable {
  let airportCode: String
  let position: Position
  let cityCode, countryCode: String
  let locationType: LocationType
  let names: Names
  let utcOffset: Double
  let timeZoneID: String
  
  enum CodingKeys: String, CodingKey {
    case airportCode = "AirportCode"
    case position = "Position"
    case cityCode = "CityCode"
    case countryCode = "CountryCode"
    case locationType = "LocationType"
    case names = "Names"
    case utcOffset = "UtcOffset"
    case timeZoneID = "TimeZoneId"
  }
}

enum LocationType: String, Codable {
  case airport = "Airport"
}

// MARK: - Names
struct Names: Codable {
  let name: [Name]
  
  enum CodingKeys: String, CodingKey {
    case name = "Name"
  }
}

// MARK: - Name
struct Name: Codable {
  let languageCode, empty: String
  
  enum CodingKeys: String, CodingKey {
    case languageCode = "@LanguageCode"
    case empty = "$"
  }
}

// MARK: - Position
struct Position: Codable {
  let coordinate: Coordinate
  
  enum CodingKeys: String, CodingKey {
    case coordinate = "Coordinate"
  }
}

// MARK: - Coordinate
struct Coordinate: Codable {
  let latitude, longitude: Double
  
  enum CodingKeys: String, CodingKey {
    case latitude = "Latitude"
    case longitude = "Longitude"
  }
}
