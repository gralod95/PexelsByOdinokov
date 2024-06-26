//
//  MainFactory.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

final class MainFactory {
    // MARK: - Nested types

    private enum DataConfiguration {
        static let domain = "https://api.pexels.com/"
        static let authorizationKey = "HuKFiM647dvmxHB5hrRzWtlvn9tbTphsCAR3XznthuVhssQz55CdWMYn"
    }

    // MARK: - Private properties

    private let useCase: GetImagesUseCase

    // MARK: - Init

    init() {
        let dataService = ImagesDataService(
            domain: DataConfiguration.domain,
            authorizationKey: DataConfiguration.authorizationKey
        )
        let imageService = ImageService()

        useCase = GetImagesUseCase(dataService: dataService, imageService: imageService)
    }

    // MARK: - Public methods

    func makeMainViewController(openDetailInfo: @escaping (_ index: Int) -> Void) -> UIViewController {
        let viewModel = MainSceneViewModel(useCase: useCase, openDetailInfo: openDetailInfo)
        let viewController = MainSceneViewController(viewModel: viewModel)
        let navigationViewController = UINavigationController(rootViewController: viewController)

        return navigationViewController
    }
    
    func makeDetailViewController(imageIndex: Int) -> UIViewController {
        let viewModel = DetailSceneViewModel(useCase: useCase, imageIndex: imageIndex)
        let viewController = DetailSceneViewController(viewModel: viewModel)

        return viewController
    }
}
