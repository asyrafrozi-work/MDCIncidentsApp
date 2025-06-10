//
//  Incident.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import CoreLocation
import UIKit

struct Incident: Identifiable, Hashable, Codable {
  let id: String
  let title: String
  let description: String?
  let type: `Type`
  let status: Status
  let location: Location
  let callTime: String
  let lastUpdated: String
  let typeIcon: URL?

  struct Location: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    let address: String

    var coordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    enum CodingKeys: String, CodingKey {
      case latitude
      case longitude
      case address = "location"
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      latitude = try container.decode(Double.self, forKey: .latitude)
      longitude = try container.decode(Double.self, forKey: .longitude)
      address = try container.decode(String.self, forKey: .address)
    }
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    description = try container.decodeIfPresent(String.self, forKey: .description)
    type = try container.decode(`Type`.self, forKey: .type)
    status = try container.decode(Status.self, forKey: .status)
    callTime = try container.decode(String.self, forKey: .callTime)
    lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
    typeIcon = try? container.decode(URL.self, forKey: .typeIcon)
    location = try Location(from: decoder)
  }
}

extension Incident {
  enum `Type`: String, Codable, CaseIterable {
    case houseFire = "House Fire"
    case bushFire = "Bush Fire"
    case fire = "Fire"
    case ambulanceResponse = "Ambulance Response"
    case floodStormTreeDown = "Flood/Storm/Tree Down"
    case mvaTransport = "MVA/Transport"
    case other = "Other"
    case undefined

    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let rawValue = try container.decode(String.self)
      self = Type(rawValue: rawValue) ?? .undefined
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      if self == .undefined {
        try container.encode("")
      } else {
        try container.encode(self.rawValue)
      }
    }
  }
}

extension Incident {
  enum Status: String, Codable {
    case onScene = "On Scene"
    case pending = "Pending"
    case underControl = "Under control"
    case outOfControl = "Out of control"
    case undefined

    var color: UIColor {
      switch self {
      case .onScene:
        return .systemBlue
      case .pending:
        return .systemOrange
      case .underControl:
        return .systemGreen
      case .outOfControl:
        return .systemRed
      case .undefined:
        return .systemGray
      }
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let rawValue = try container.decode(String.self)
      self = Status(rawValue: rawValue) ?? .undefined
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      if self == .undefined {
        try container.encode("")
      } else {
        try container.encode(self.rawValue)
      }
    }
  }
}
