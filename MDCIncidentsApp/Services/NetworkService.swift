//
//  NetworkService.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import Foundation
import RxSwift

class NetworkService {

  private let urlSession: URLSession
  private let scheduler: SchedulerType

  init(urlSession: URLSession = .shared,
               scheduler: SchedulerType = MainScheduler.instance) {
    self.urlSession = urlSession
    self.scheduler = scheduler
  }
  
  func fetch<T: Decodable>(request: NetworkRequest) -> Single<T> {
    guard let url = request.fullURL else {
      return .error(NetworkError.invalidURL)
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.httpMethod.rawValue.uppercased()
    urlRequest.httpBody = request.httpBody
    return urlSession.rx.data(request: URLRequest(url: url))
      .map { try JSONDecoder().decode(T.self, from: $0)}
      .observe(on: scheduler)
      .asSingle()
  }
}
