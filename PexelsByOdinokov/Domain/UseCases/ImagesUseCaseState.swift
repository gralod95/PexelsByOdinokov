//
//  ImagesUseCaseState.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

actor ImagesUseCaseState {
    // MARK: - Private properties

    private var isLoading: Bool = false
    private var nextPage: Int = 1
    private var data: [ImageData] = []

    // MARK: - Public methods

    func getNextPage() -> Int? {
        guard !isLoading else { return nil }

        isLoading = true
        return nextPage
    }

    func append(newData: [ImageData]) {
        let ids = Set(data.map(\.id))
        data.append(contentsOf: newData.filter { !ids.contains($0.id) })
        nextPage += 1
        isLoading = false
    }

    func getData() -> [ImageShortInfo] {
        return data
    }

    func getPreviewImageUrlOrImage(index: Int) -> UrlOrImage {
        guard data.count > index else { return .outOfScopeError }

        let imageData = data[index]

        switch imageData.previewImage {
        case .loaded(let image):
            return .image(image)
        case .notLoaded:
            return .url(imageData.previewUrl)
        }
    }

    func set(previewImage: UIImage, index: Int) {
        guard data.count > index else { return }

        data[index].previewImage = .loaded(previewImage)
    }

    func getImageUrlOrImage(index: Int) -> UrlOrImage {
        guard data.count > index else { return .outOfScopeError }

        let imageData = data[index]

        switch imageData.image {
        case .loaded(let image):
            return .image(image)
        case .notLoaded:
            return .url(imageData.imageUrl)
        }
    }

    func set(image: UIImage, index: Int) {
        guard data.count > index else { return }

        data[index].image = .loaded(image)
    }
}
