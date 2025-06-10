//
//  AppCoordinator.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import UIKit

class AppCoordinator {

  private let window: UIWindow
  private let dependencies: BaseDependencies

  init(window: UIWindow) {
    self.window = window
    self.dependencies = DefaultBaseDependencies()
  }

  func start() {
    if UIDevice.current.userInterfaceIdiom == .pad {
      setupIPadInterface()
    } else {
      setupIPhoneInterface()
    }
    window.makeKeyAndVisible()
  }

  private func setupIPadInterface() {
    let splitViewController = UISplitViewController(style: .doubleColumn)
    let listViewController = IncidentListViewController(
      viewModel: .init(networkService: dependencies.networkService)
    )
    let primaryNV = UINavigationController(rootViewController: listViewController)
    splitViewController.setViewController(primaryNV, for: .primary)
    splitViewController.preferredDisplayMode = .oneBesideSecondary
    splitViewController.presentsWithGesture = true
    window.rootViewController = splitViewController
  }

  private func setupIPhoneInterface() {
    let listViewController = IncidentListViewController(
      viewModel: .init(networkService: dependencies.networkService)
    )
    let navigationController = UINavigationController(rootViewController: listViewController)
    window.rootViewController = navigationController
  }
}
