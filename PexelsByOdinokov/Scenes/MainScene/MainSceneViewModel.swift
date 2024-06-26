//
//  MainSceneViewModel.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

final class MainSceneViewModel {
    // MARK: - Private properties

    private let useCase: GetImagesUseCase
    private let openDetailInfo: (_ index: Int) -> Void
    private var isFirstData: Bool = true

    // MARK: - Public properties

    var viewDataWasUpdated: ((_ data: MainSceneViewData, _ isAnimated: Bool) -> Void)?
    var cellImageDataUpdated: ((_ data: MainSceneTableViewCellData.Image, _ index: Int) -> Void)?

    // MARK: - Init

    init(useCase: GetImagesUseCase, openDetailInfo: @escaping (_ index: Int) -> Void) {
        self.useCase = useCase
        self.openDetailInfo = openDetailInfo
    }

    // MARK: - Public methods

    func didShowen() {
        guard isFirstData else { return }

        viewDataWasUpdated?(.loading, false)
        getMoreData()
    }

    func didReachedBottom() {
        getMoreData()
    }

    func willDisplayCell(_ index: Int) {
        Task {
            let data = await useCase.getImagePreview(index: index)

            await update(cellImageData: data, for: index)
        }
    }

    func didTapCell(_ index: Int) {
        openDetailInfo(index)
    }

    // MARK: - Private methods

    private func getMoreData() {
        Task {
            guard let data = await useCase.getMoreImagesData() else { return }

            await set(data: data, animated: !isFirstData)
            isFirstData = false
        }
    }

    @MainActor
    private func set(data: Result<[ImageShortInfo], UseCaseError>, animated: Bool) async {
        switch data {
        case .success(let data):
            let cellsData: [MainSceneTableViewCellData] = data
                .map { 
                    .init(
                        id: $0.id,
                        title: $0.imageName,
                        subtitle: $0.ownerName,
                        image: getImage(imageState: $0.previewImage)
                    )
                }

            viewDataWasUpdated?(.cellsData(cellsData), animated)
        case .failure(let error):
            let errorData: LoadingErrorViewData = switch error {
            case .internetError:
                    .noInternet
            case .serviceError:
                    .serviceError
            }

            viewDataWasUpdated?(.loadingError(errorData), animated)
        }
    }
    
    @MainActor
    private func update(cellImageData: Result<ImageState, UseCaseError>, for index: Int) async {
        cellImageDataUpdated?(getImage(gettingImageResult: cellImageData), index)
    }

    private func getImage(gettingImageResult: Result<ImageState, UseCaseError>) -> MainSceneTableViewCellData.Image {
        switch gettingImageResult {
        case .success(let imageState):
            return getImage(imageState: imageState)
        case .failure:
            return .failedToLoad
        }
    }

    private func getImage(imageState: ImageState) -> MainSceneTableViewCellData.Image {
        switch imageState {
        case .notLoaded:
            return .loading
        case .loaded(let image):
            return .image(image)
        }
    }
}
