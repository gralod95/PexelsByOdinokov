//
//  MainCoordinator.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 20.06.2024.
//

import UIKit

final class MainCoordinator {
    // MARK: - Private properties

    private var window: UIWindow?
    private let factory: MainFactory

    // MARK: - Init

    init(mainFactory: MainFactory) {
        self.factory = mainFactory
    }

    // MARK: - Public methods

    func startMainScene(window: UIWindow) {
        self.window = window

        let viewController = factory.makeMainViewController(openDetailInfo: startDetailInfoScene(imageIndex:))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    func startDetailInfoScene(imageIndex: Int) {
        let detailInfoViewController = factory.makeDetailViewController(imageIndex: imageIndex)
        push(viewController: detailInfoViewController)
    }

    // MARK: - Private methods

    private func push(viewController: UIViewController) {
        guard let navigationController = (window?.rootViewController as? UINavigationController) else { return }

        navigationController.pushViewController(viewController, animated: true)
    }
}
