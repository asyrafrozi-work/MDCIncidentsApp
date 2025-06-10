//
//  BaseViewController.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import UIKit

class BaseViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
  }

  func route(to viewController: UIViewController) {
    if let splitViewController = view.window?.rootViewController as? UISplitViewController {
      splitViewController.showDetailViewController(viewController, sender: self)
    } else {
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
}
