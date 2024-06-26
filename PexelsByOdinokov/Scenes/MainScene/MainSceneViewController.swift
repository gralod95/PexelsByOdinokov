//
//  MainSceneViewController.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

final class MainSceneViewController: UIViewController {
    // MARK: - Private properties

    private lazy var contentView: MainSceneView = .init()
    private let viewModel: MainSceneViewModel

    // MARK: - Init

    init(viewModel: MainSceneViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods

    override func loadView() {
        view = contentView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDataWasUpdated = { [weak self] in
            guard let self else {
                assertionFailure("MainSceneViewController.viewModel has reference cycle!")
                return
            }

            self.contentView.set(viewData: $0, animated: $1)
        }
        viewModel.cellImageDataUpdated = { [weak self] in
            guard let self else {
                assertionFailure("MainSceneViewController.viewModel has reference cycle!")
                return
            }

            self.contentView.set(cellImageData: $0, for: $1)
        }
        contentView.set(delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.didShowen()
    }
}

// MARK: - +UITableViewDelegate

extension MainSceneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCell(indexPath.row)

        guard tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row else { return }

        viewModel.didReachedBottom()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapCell(indexPath.row)
    }
}
