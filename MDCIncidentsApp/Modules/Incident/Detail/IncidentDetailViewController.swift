//
//  IncidentDetailViewController.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import Kingfisher

class IncidentDetailViewController: BaseViewController {
  private let viewModel: IncidentDetailViewModel
  private let mapView = MKMapView()
  private let scrollView = UIScrollView()
  private let contentView = UIStackView()
  private let disposeBag = DisposeBag()

  init(viewModel: IncidentDetailViewModel) {
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
    configureMap()
  }

  private func setupBindings() {
    navigationItem.rightBarButtonItem?.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.viewModel.openInMaps()
      }
      .disposed(by: disposeBag)

    viewModel.mapRegion
      .bind(to: mapView.rx.region)
      .disposed(by: disposeBag)
    
    viewModel.descriptionCopied
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        self?.showCopiedAlert()
      })
      .disposed(by: disposeBag)
  }

  private func setupUI() {
    title = viewModel.incident.title

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "arrow.trianglehead.turn.up.right.diamond.fill"),
      style: .plain,
      target: self,
      action: nil
    )

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)

    contentView.axis = .vertical
    contentView.spacing = 16
    contentView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentView)

    mapView.translatesAutoresizingMaskIntoConstraints = false
    mapView.layer.cornerRadius = 12
    mapView.clipsToBounds = true
    mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true

    contentView.addArrangedSubview(mapView)
    contentView.addArrangedSubview(createDetailsView())

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
    ])
  }

  private func createDetailsView() -> UIView {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.addArrangedSubview(createDetailRow(title: "Location", value: viewModel.incident.location.address))
    stackView.addArrangedSubview(createDetailRow(title: "Status", value: viewModel.incident.status.rawValue))
    stackView.addArrangedSubview(createDetailRow(title: "Type", value: viewModel.incident.type.rawValue))
    stackView.addArrangedSubview(createDetailRow(title: "Call Time", value: viewModel.incident.callTime))

    if let description = viewModel.incident.description {
      let descriptionRow = createDetailRow(title: "Description", value: description)
      stackView.addArrangedSubview(descriptionRow)
      let tapGesture = UITapGestureRecognizer()
      descriptionRow.addGestureRecognizer(tapGesture)
      descriptionRow.isUserInteractionEnabled = true

      tapGesture.rx.event
        .bind { [weak self] _ in
          self?.viewModel.copyDescription()
        }
        .disposed(by: disposeBag)
    }

    return stackView
  }

  private func createDetailRow(title: String, value: String) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8

    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
    titleLabel.textColor = .secondaryLabel

    stackView.addArrangedSubview(titleLabel)

    let valueLabel = UILabel()
    valueLabel.text = value
    valueLabel.font = .systemFont(ofSize: 16, weight: .regular)
    valueLabel.numberOfLines = 0
    stackView.addArrangedSubview(valueLabel)

    return stackView
  }

  private func configureMap() {
    let annotation = MKPointAnnotation()
    annotation.coordinate = viewModel.incident.location.coordinate
    annotation.title = viewModel.incident.title
    mapView.addAnnotation(annotation)

    mapView.register(
      IncidentAnnotationView.self,
      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
    )
  }

  private func showCopiedAlert() {
    let alert = UIAlertController(
      title: "Description Copied",
      message: nil,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

class IncidentAnnotationView: MKAnnotationView {
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    backgroundColor = .white
    layer.cornerRadius = 22
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 4

    let imageView = UIImageView(image: UIImage(systemName: "location.fill"))
    imageView.tintColor = .systemBlue
    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 24),
      imageView.heightAnchor.constraint(equalToConstant: 24)
    ])
  }
}
