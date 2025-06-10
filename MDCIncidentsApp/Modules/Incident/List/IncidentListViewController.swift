//
//  IncidentListViewController.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import Kingfisher
import RxSwift
import RxCocoa
import UIKit

class IncidentListViewController: BaseViewController {

  private var tableView: UITableView!
  private var searchController: UISearchController!
  private var dataSource: UITableViewDiffableDataSource<Section, Incident>!

  private let viewModel: IncidentListViewModel
  private let disposeBag = DisposeBag()

  private enum Section {
    case main
  }

  init(viewModel: IncidentListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBindings()
    viewModel.fetchIncidents()
  }

  private func setupUI() {
    title = "Incidents"

    tableView = UITableView(frame: view.bounds, style: .plain)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(tableView)

    tableView.register(IncidentCell.self, forCellReuseIdentifier: "IncidentCell")
    tableView.delegate = self

    searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController

    let refreshControl = UIRefreshControl()
    tableView.refreshControl = refreshControl

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "arrow.up.arrow.down"),
      style: .plain,
      target: nil,
      action: nil
    )

    dataSource = UITableViewDiffableDataSource<Section, Incident>(
      tableView: tableView
    ) { tableView, indexPath, incident in
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "IncidentCell",
        for: indexPath
      ) as! IncidentCell
      cell.configure(with: incident)
      return cell
    }
  }

  private func setupBindings() {
    searchController.searchBar.rx.text
      .orEmpty
      .bind(to: viewModel.searchText)
      .disposed(by: disposeBag)

    tableView.refreshControl?.rx.controlEvent(.valueChanged)
      .bind { [weak self] in
        self?.viewModel.fetchIncidents()
      }
      .disposed(by: disposeBag)

    navigationItem.rightBarButtonItem?.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        let newValue = !self.viewModel.sortAscending.value
        self.viewModel.sortAscending.accept(newValue)
        let imageName = newValue ? "arrow.up" : "arrow.down"
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
      }
      .disposed(by: disposeBag)

    viewModel.filteredAndSortedIncidents
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] incidents in
        self?.updateDataSource(with: incidents)
      })
      .disposed(by: disposeBag)

    viewModel.isLoading
      .bind { [weak self] isLoading in
        if !isLoading {
          self?.tableView.refreshControl?.endRefreshing()
        }
      }
      .disposed(by: disposeBag)

    viewModel.error
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] error in
        self?.showError(error)
      })
      .disposed(by: disposeBag)
  }

  private func updateDataSource(with incidents: [Incident]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Incident>()
    snapshot.appendSections([.main])
    snapshot.appendItems(incidents)
    dataSource.apply(snapshot, animatingDifferences: true)
  }

  private func showError(_ error: Error) {
    let alert = UIAlertController(
      title: "Error",
      message: error.localizedDescription,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

extension IncidentListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let incident = dataSource.itemIdentifier(for: indexPath) else { return }
    let viewModel = IncidentDetailViewModel(incident: incident)
    let detailVC = IncidentDetailViewController(viewModel: viewModel)
    route(to: detailVC)
  }
}
