//
//  DetailSceneViewModel.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 20.06.2024.
//

import UIKit

final class DetailSceneViewModel {
    // MARK: - Private properties

    private let useCase: GetImagesUseCase
    private let imageIndex: Int

    // MARK: - Public properties

    var viewDataWasUpdated: ((DetailSceneViewData) -> Void)?

    // MARK: - Init

    init(useCase: GetImagesUseCase, imageIndex: Int) {
        self.useCase = useCase
        self.imageIndex = imageIndex
    }

    // MARK: - Public methods

    func didShowen() {
        viewDataWasUpdated?(.loading)
        Task {
            let data = await useCase.getImage(index: imageIndex)
            await set(data: data)
        }
    }

    // MARK: - Private methods

    @MainActor
    private func set(data: Result<UIImage, UseCaseError>) async {
        switch data {
        case .success(let image):
            viewDataWasUpdated?(.image(image))
        case .failure(let error):
            let errorData: LoadingErrorViewData = switch error {
            case .internetError:
                    .noInternet
            case .serviceError:
                    .serviceError
            }

            viewDataWasUpdated?(.loadingError(errorData))
        }
    }
}
