//
//  LoadingErrorView.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

final class LoadingErrorView: UIView {
    // MARK: - Nested types

    private enum Constants {
        static let imageName: String = "exclamationmark.triangle.fill"
        enum Text {
            static let networkError: String = "You have internet connection's problem"
            static let serviceError: String = "Service is unavailable"
        }
    }

    // MARK: - Private properties

    private let imageView = UIImageView(image: .init(systemName: Constants.imageName))
    private let label = UILabel(frame: .zero)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 16
        backgroundColor = .secondarySystemBackground
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func set(data: LoadingErrorViewData) {
        switch data {
        case .noInternet:
            label.text = Constants.Text.networkError
        case .serviceError:
            label.text = Constants.Text.serviceError
        }
    }

    // MARK: - Private methods

    private func setup() {
        label.textAlignment = .center
        
        [imageView, label]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }

        NSLayoutConstraint.activate(
            [
                // imageView
                imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 130),
                imageView.widthAnchor.constraint(equalToConstant: 130),

                // label
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ]
        )
    }
}
