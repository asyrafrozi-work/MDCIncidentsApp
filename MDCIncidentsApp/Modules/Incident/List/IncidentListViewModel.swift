//
//  IncidentListViewModel.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import Foundation
import RxSwift
import RxCocoa

class IncidentListViewModel {

  // Outputs
  let incidents: BehaviorRelay<[Incident]> = BehaviorRelay(value: [])
  let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
  let error: PublishRelay<Error> = PublishRelay()

  // Inputs
  let searchText: BehaviorRelay<String> = BehaviorRelay(value: "")
  let sortAscending: BehaviorRelay<Bool> = BehaviorRelay(value: false)

  // Private
  private let networkService: NetworkService
  private let scheduler: SchedulerType
  private let disposeBag = DisposeBag()

  // Computed
  var filteredAndSortedIncidents: Observable<[Incident]> {
    Observable.combineLatest(incidents, searchText, sortAscending)
      .map { incidents, searchText, sortAscending in
        let sorted = incidents.sorted { incident1, incident2 in
          sortAscending ? incident1.lastUpdated < incident2.lastUpdated : incident1.lastUpdated > incident2.lastUpdated
        }

        if searchText.isEmpty {
          return sorted
        }

        return sorted.filter { incident in
          incident.title.contains(searchText) ||
          incident.status.rawValue.localizedCaseInsensitiveContains(searchText) ||
          incident.location.latitude.description.localizedCaseInsensitiveContains(searchText) ||
          incident.location.longitude.description.localizedCaseInsensitiveContains(searchText) ||
          incident.location.address.localizedCaseInsensitiveContains(searchText) ||
          incident.description?.localizedCaseInsensitiveContains(searchText) ?? false
        }
      }
  }

  init(networkService: NetworkService,
       scheduler: SchedulerType = MainScheduler.instance) {
    self.networkService = networkService
    self.scheduler = scheduler
  }

  func fetchIncidents() {
    isLoading.accept(true)

    networkService.fetch(request: .incidents)
      .observe(on: scheduler)
      .subscribe(
        onSuccess: { [weak self] incidents in
          self?.incidents.accept(incidents)
          self?.isLoading.accept(false)
        },
        onFailure: { [weak self] error in
          self?.error.accept(error)
          self?.isLoading.accept(false)
        }
      )
      .disposed(by: disposeBag)
  }
}
