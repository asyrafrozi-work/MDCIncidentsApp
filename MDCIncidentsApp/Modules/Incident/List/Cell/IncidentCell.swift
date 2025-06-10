//
//  IncidentCell.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import UIKit

class IncidentCell: UITableViewCell {
  private let iconImageView = UIImageView()
  private let dateLabel = UILabel()
  private let titleLabel = UILabel()
  private let statusView = UIView()
  private let statusLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupContraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    accessoryType = .disclosureIndicator

    iconImageView.contentMode = .scaleAspectFit
    iconImageView.tintColor = .systemBlue
    contentView.addSubview(iconImageView)

    dateLabel.font = .systemFont(ofSize: 12)
    dateLabel.textColor = .secondaryLabel
    contentView.addSubview(dateLabel)

    titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
    titleLabel.numberOfLines = 2
    contentView.addSubview(titleLabel)

    statusView.layer.cornerRadius = 8
    statusLabel.font = .systemFont(ofSize: 12, weight: .medium)
    statusLabel.textColor = .white
    statusView.addSubview(statusLabel)
    contentView.addSubview(statusView)
  }

  private func setupContraints() {
    [iconImageView, dateLabel, titleLabel, statusView, statusLabel].forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: 44),
      iconImageView.heightAnchor.constraint(equalToConstant: 44),

      dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

      titleLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
      titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),

      statusView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
      statusView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      statusView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

      statusLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: 8),
      statusLabel.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -8),
      statusLabel.topAnchor.constraint(equalTo: statusView.topAnchor, constant: 4),
      statusLabel.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: -4)
    ])
  }

  func configure(with incident: Incident) {
    iconImageView.kf.setImage(with: incident.typeIcon)
    titleLabel.text = incident.title
    dateLabel.text = incident.lastUpdated
    statusLabel.text = incident.status.rawValue
    statusView.backgroundColor = incident.status.color
  }
}
