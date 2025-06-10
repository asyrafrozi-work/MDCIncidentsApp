//
//  NetworkError.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case decodingError
  case serverError(String)
}
