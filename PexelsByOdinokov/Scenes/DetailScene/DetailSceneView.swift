//
//  DetailSceneView.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 20.06.2024.
//

import UIKit

final class DetailSceneView: UIView {
    // MARK: - Private properties

    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let loaderView = UIActivityIndicatorView()
    private let errorView = LoadingErrorView()

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        backgroundColor = .systemBackground
        setupScrollView()
        setupImageView()
        setupLoaderView()
        setupErrorView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func set(viewData: DetailSceneViewData) {
        switch viewData {
        case .loading:
            loaderView.startAnimating()
        case .image(let image):
            loaderView.stopAnimating()
            Task {
                imageView.image = await image.byPreparingForDisplay()
            }
        case .loadingError(let error):
            errorView.set(data: error)
            errorView.isHidden = false
        }
    }

    // MARK: - Private methods

    private func setupScrollView() {
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.layer.cornerRadius = 8
        scrollView.delegate = self

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
                scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
            ]
        )
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray4

        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)

        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            ]
        )
    }

    private func setupLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loaderView)

        NSLayoutConstraint.activate(
            [
                loaderView.centerYAnchor.constraint(equalTo: centerYAnchor),
                loaderView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ]
        )
    }

    private func setupErrorView() {
        errorView.isHidden = true

        errorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorView)
        NSLayoutConstraint.activate(
            [
                errorView.centerYAnchor.constraint(equalTo: centerYAnchor),
                errorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                errorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ]
        )
    }
}
extension DetailSceneView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
