//
//  ImagesDataService.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import Foundation

final class ImagesDataService {
    // MARK: - Nested types

    private enum Constants {
        static let authorizationKey = "Authorization"
        static let validCodesOfResponse = 200...299
    }

    private enum HttpMethod {
        case loadImagesData

        var path: String {
            switch self {
            case .loadImagesData:
                return "v1/curated"
            }
        }
        var httpMethod: String {
            switch self {
            case .loadImagesData:
                return "GET"
            }
        }
    }

    // MARK: - Private properties

    private let domain: String
    private let authorizationKey: String

    // MARK: - Init

    init(domain: String, authorizationKey: String) {
        self.domain = domain
        self.authorizationKey = authorizationKey
    }

    // MARK: - Public methods

    func loadImagesData(page: Int) async -> Result<ImagesDataDto, ErrorDto> {
        guard let request = makeRequest(
            method: .loadImagesData,
            queryItems: [.init(name: "page", value: String(page))]
        ) else {
            return .failure(.serviceError)
        }

        return await send(request: request)
    }

    // MARK: - Private methods

    private func makeRequest(method: HttpMethod, queryItems: [URLQueryItem]) -> URLRequest? {
        guard case let .success(url) = makeUrl(path: method.path, queryItems: queryItems) else {
            assertionFailure("Url making failed!")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.httpMethod
        request.setValue(authorizationKey, forHTTPHeaderField: Constants.authorizationKey)
#if DEBUG
        request.cachePolicy = .reloadIgnoringLocalCacheData
#endif

        return request
    }

    private func makeUrl(path: String, queryItems: [URLQueryItem]) -> Result<URL, Error> {
        guard var urlComponents = URLComponents(string: domain + path) else {
            return .failure(URLError(.badURL))
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            return .failure(URLError(.badURL))
        }

        return .success(url)
    }

    private func send<Response: Decodable>(request: URLRequest) async -> Result<Response, ErrorDto> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  Constants.validCodesOfResponse.contains(httpResponse.statusCode)
            else {
                return .failure(.serviceError)
            }

            let decoder = JSONDecoder()
            let imagesData = try decoder.decode(Response.self, from: data)
#if DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response Body: \(jsonString)")
            }
#endif
            return .success(imagesData)
        } catch {
            guard let error = error as? URLError, [.notConnectedToInternet, .timedOut].contains(error.code)
            else { return .failure(.serviceError) }

            return .failure(.internetError)
        }
    }
}
