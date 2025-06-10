//
//  NetworkRequest.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import Foundation

enum NetworkRequest {
  case incidents
}

// MARK: URL
extension NetworkRequest {
  private var baseURL: String {
    "https://run.mocky.io"
  }

  private var version: String {
    "/v3"
  }

  var path: String {
    switch self {
    case .incidents:
      return "/7a049a64-4a1c-429d-889c-bf0aae678b47"
    }
  }

  var fullURL: URL? {
    return URL(string: "\(baseURL)\(version)\(path)")
  }
}

// MARK: HTTP Method
extension NetworkRequest {
  enum HTTPMethod: String {
    case get
    case post
  }

  var httpMethod: HTTPMethod {
    switch self {
    case .incidents:
      return .get
    }
  }
}

// MARK: HTTP Body
extension NetworkRequest {
  var httpBody: Data? {
    switch self {
    case .incidents:
      return nil
    }
  }
}
