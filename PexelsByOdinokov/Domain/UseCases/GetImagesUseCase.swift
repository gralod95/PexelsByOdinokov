//
//  GetImagesUseCase.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

final class GetImagesUseCase {
    // MARK: - Private properties

    private let dataService: ImagesDataService
    private let imageService: ImageService
    private let state: ImagesUseCaseState = .init()

    // MARK: - Init

    init(dataService: ImagesDataService, imageService: ImageService) {
        self.dataService = dataService
        self.imageService = imageService
    }

    // MARK: - Public methods

    func getMoreImagesData() async -> Result<[ImageShortInfo], UseCaseError>? {
        guard let page = await state.getNextPage() else {
            return nil
        }

        let result = await dataService.loadImagesData(page: page)

        switch result {
        case .success(let dto):
            let newData = dto.photos.map { 
                ImageData(
                    id: $0.id,
                    imageName: $0.alt,
                    ownerName: $0.photographer,
                    previewUrl: $0.src.small,
                    imageUrl: $0.src.original
                )
            }

            await state.append(newData: newData)
            
            return await .success(state.getData())
        case .failure(let error):
            let data = await state.getData()
            return data.isEmpty ? .failure(getError(from: error)) : .success(data)
        }
    }

    func getImagePreview(index: Int) async -> Result<ImageState, UseCaseError> {
        let previewImageData = await state.getPreviewImageUrlOrImage(index: index)

        switch previewImageData {
        case .url(let previewImageUrlText):
            switch await loadImage(previewImageUrlText) {
            case .success(let image):
                await state.set(previewImage: image, index: index)
                return .success(.loaded(image))
            case .failure(let error):
                return .failure(error)
            }
        case .image(let image):
            return .success(.loaded(image))
        case .outOfScopeError:
            assertionFailure("User opened image details for invalid image index!")
            return .failure(.serviceError)
        }
    }

    func getImage(index: Int) async -> Result<UIImage, UseCaseError> {
        let imageData = await state.getImageUrlOrImage(index: index)

        switch imageData {
        case .url(let imageUrlText):
            switch await loadImage(imageUrlText) {
            case .success(let image):
                await state.set(image: image, index: index)
                return .success(image)
            case .failure(let error):
                return .failure(error)
            }
        case .image(let image):
            return .success(image)
        case .outOfScopeError:
            assertionFailure("User opened image details for invalid image index!")
            return .failure(.serviceError)
        }
    }

    // MARK: - Private methods

    private func getError(from errorDto: ErrorDto) -> UseCaseError {
        switch errorDto {
        case .internetError:
            return .internetError
        case .serviceError:
            return .serviceError
        }
    }

    private func loadImage(_ imageUrlText: String) async -> Result<UIImage, UseCaseError> {
        switch await imageService.loadImage(urlText: imageUrlText) {
        case .success(let data):
            switch UIImage(data: data) {
            case .some(let imageContent):
                return .success(imageContent)
            case .none:
                return .failure(.serviceError)
            }
        case .failure(let error):
            return .failure(getError(from: error))
        }
    }
}
