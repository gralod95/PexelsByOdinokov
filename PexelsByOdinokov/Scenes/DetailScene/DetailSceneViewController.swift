//
//  DetailSceneViewController.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 17.06.2024.
//

import UIKit

final class DetailSceneViewController: UIViewController {
    // MARK: - Private properties

    private lazy var contentView: DetailSceneView = .init()
    private let viewModel: DetailSceneViewModel

    // MARK: - Init

    init(viewModel: DetailSceneViewModel) {
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

            contentView.set(viewData: $0)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.didShowen()
    }
}
