//
//  MainSceneTableViewCell.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

final class MainSceneTableViewCell: UITableViewCell {
    // MARK: - Nested types

    private enum Constants {
        static let errorImageName: String = "exclamationmark.triangle.fill"
    }

    // MARK: - Private properties

    private let content = UIView()
    private let iconView = UIImageView()
    private let iconLoadingIndicator = UIActivityIndicatorView()
    private let title = UILabel()
    private let subtitle = UILabel()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
        setupContentView()
        setupContent()
        setupIconView()
        setupIconLoadingIndicator()
        setupTitle()
        setupSubtitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func set(viewData: MainSceneTableViewCellData) {
        title.text = viewData.title
        subtitle.text = viewData.subtitle

        switch viewData.image {
        case .loading:
            iconLoadingIndicator.startAnimating()
            iconView.image = nil
        case .image(let image):
            iconLoadingIndicator.stopAnimating()
            Task {
                iconView.image = await image.byPreparingForDisplay()
            }
        case .failedToLoad:
            iconLoadingIndicator.stopAnimating()
            iconView.image = .init(systemName: Constants.errorImageName)
        }
    }

    func set(imageData: MainSceneTableViewCellData.Image) {
        switch imageData {
        case .loading:
            iconLoadingIndicator.startAnimating()
            iconView.image = nil
        case .image(let image):
            iconLoadingIndicator.stopAnimating()
            Task {
                iconView.image = await image.byPreparingForDisplay()
            }
        case .failedToLoad:
            iconLoadingIndicator.stopAnimating()
            iconView.image = .init(systemName: Constants.errorImageName)
        }
    }

    // MARK: - Private methods
    
    private func setup() {
        selectionStyle = .none
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.setupContentView()
        }
    }

    private func setupContentView() {
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 2
        contentView.layer.masksToBounds = false
    }

    private func setupContent() {
        content.backgroundColor = .secondarySystemBackground
        content.layer.cornerRadius = 16

        content.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(content)


        NSLayoutConstraint.activate(
            [
                content.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ]
        )
    }

    private func setupIconView() {
        iconView.contentMode = .scaleAspectFit
        iconView.backgroundColor = .systemGray4
        iconView.layer.cornerRadius = 8

        iconView.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(iconView)

        NSLayoutConstraint.activate(
            [
                iconView.topAnchor.constraint(equalTo: content.topAnchor, constant: 16),
                iconView.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -16),
                iconView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
                iconView.heightAnchor.constraint(equalToConstant: 130),
                iconView.widthAnchor.constraint(equalToConstant: 130)
            ]
        )
    }

    private func setupIconLoadingIndicator() {
        iconLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(iconLoadingIndicator)

        NSLayoutConstraint.activate(
            [
                iconLoadingIndicator.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
                iconLoadingIndicator.centerXAnchor.constraint(equalTo: iconView.centerXAnchor)
            ]
        )
    }

    private func setupTitle() {
        title.numberOfLines = 0
        title.font = .preferredFont(forTextStyle: .headline)

        title.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(title)

        NSLayoutConstraint.activate(
            [
                title.topAnchor.constraint(equalTo: content.topAnchor, constant: 16),
                title.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
                title.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16)
            ]
        )
    }

    private func setupSubtitle() {
        subtitle.numberOfLines = 0
        subtitle.font = .preferredFont(forTextStyle: .subheadline)

        subtitle.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(subtitle)

        NSLayoutConstraint.activate(
            [
                subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
                subtitle.bottomAnchor.constraint(lessThanOrEqualTo: content.bottomAnchor, constant: -16),
                subtitle.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
                subtitle.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16)
            ]
        )
    }
}
