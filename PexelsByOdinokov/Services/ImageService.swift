//
//  ImageService.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 17.06.2024.
//

import Foundation

final class ImageService {
    // MARK: - Nested types

    private enum Constants {
        static let validCodesOfResponse = 200...299
    }

    // MARK: - Public methods

    func loadImage(urlText: String) async -> Result<Data, ErrorDto> {
        guard let request = makeRequest(urlText: urlText) else {
            return .failure(.serviceError)
        }

        return await send(request: request)
    }

    // MARK: - Private methods

    private func makeRequest(urlText: String) -> URLRequest? {
        guard let url = URL(string: urlText) else {
            assertionFailure("Url making failed!")
            return nil
        }

        var request = URLRequest(url: url)
#if DEBUG
        request.cachePolicy = .reloadIgnoringLocalCacheData
#endif

        return request
    }

    private func send(request: URLRequest) async -> Result<Data, ErrorDto> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  Constants.validCodesOfResponse.contains(httpResponse.statusCode)
            else {
                return .failure(.serviceError)
            }

            return .success(data)
        } catch {
            guard let error = error as? URLError, [.notConnectedToInternet, .timedOut].contains(error.code)
            else { return .failure(.serviceError) }

            return .failure(.internetError)
        }
    }
}
