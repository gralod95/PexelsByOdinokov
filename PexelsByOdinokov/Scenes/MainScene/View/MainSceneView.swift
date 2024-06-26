//
//  MainSceneView.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

final class MainSceneView: UIView {
    // MARK: - Nested types

    fileprivate enum Constants {
        static let cellIdentifier: String = "Cell"
    }

    // MARK: - Private properties

    private var diffableDataSource: UITableViewDiffableDataSource<Int, MainSceneTableViewCellData>?
    private let tableView: UITableView = .init(frame: .zero, style: .plain)
    private let errorView: LoadingErrorView = .init()
    private let loaderView: UIActivityIndicatorView = .init()

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        setupTableView()
        setupErrorView()
        setupLoaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func set(viewData: MainSceneViewData, animated: Bool) {
        switch viewData {
        case .loading:
            loaderView.startAnimating()
        case .loadingError(let error):
            set(error: error)
        case .cellsData(let cellsData):
            loaderView.stopAnimating()
            set(cellsData: cellsData, animated: animated)
        }
    }

    func set(cellImageData: MainSceneTableViewCellData.Image, for index: Int) {
        let cell = tableView.cellForRow(at: .init(row: index, section: .zero)) as? MainSceneTableViewCell
        cell?.set(imageData: cellImageData)
    }

    func set(delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    // MARK: - Private methods

    private func setupTableView() {
        diffableDataSource = .init(tableView: tableView, cellProvider: provideCell(tableView:indexPath:data:))

        tableView.register(MainSceneTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.separatorStyle = .none

        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: topAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
    }

    private func setupLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loaderView)
        NSLayoutConstraint.activate(
            [
                loaderView.centerYAnchor.constraint(equalTo: centerYAnchor),
                loaderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                loaderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
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

    private func provideCell(
        tableView: UITableView,
        indexPath: IndexPath,
        data: MainSceneTableViewCellData
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? MainSceneTableViewCell else {
            assertionFailure("TableView has wrong setup!")
            return .init()
        }

        cell.set(viewData: data)

        return cell
    }

    private func set(cellsData: [MainSceneTableViewCellData], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MainSceneTableViewCellData>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(cellsData)

        diffableDataSource?.apply(snapshot, animatingDifferences: animated)
    }

    private func set(error: LoadingErrorViewData) {
        errorView.set(data: error)
        errorView.isHidden = false
    }
}

