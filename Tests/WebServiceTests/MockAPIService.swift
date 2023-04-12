//
//  MockAPIClient.swift
//  
//
//  Created by Linkon Sid on 30/3/23.
//

import Foundation
@testable import WebService

final class MockAPIService {
    private var apiClient: WebServiceProtocol
    private var url = "https://binarysid.github.io/profile/api/carlist.json"

    init(apiClient: WebServiceProtocol) {
        self.apiClient = apiClient
    }

    func getTransactionList() async throws -> CarArticleData {
        do {
            guard let request = getURLRequest(baseURL: url) else {
                throw NetworkError.badURL
            }
            let (data, response) = try await apiClient.fetch(request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.serviceNotFound
            }
            let userData = try apiClient.decode(type: CarArticleData.self, from: data)
            return userData
        } catch {
            throw NetworkError.invalidJson
        }
    }
}

extension MockAPIService {
    private func getURLRequest(baseURL: String, queryParams: [String: String]? = nil, headers: [String: String]? = nil) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        if let queryParams = queryParams {
            var queryItems: [URLQueryItem] = []
            for (key, value) in queryParams {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}
