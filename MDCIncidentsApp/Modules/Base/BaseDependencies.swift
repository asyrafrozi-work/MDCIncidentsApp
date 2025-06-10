//
//  BaseDependencies.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

protocol BaseDependencies {
  var networkService: NetworkService { get set }
}

class DefaultBaseDependencies: BaseDependencies {
  var networkService = NetworkService()
}
