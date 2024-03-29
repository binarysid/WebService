//
//  MockAPIClient.swift
//  
//
//  Created by Linkon Sid on 30/3/23.
//

import Foundation
@testable import WebService

final class MockAPIClient {
    private var url = "https://binarysid.github.io/profile/api/carlist.json"
    private var httpClient = HTTPClient(timeoutRequestInterval: 2.0)

    func getTransactionList() async throws -> CarArticleData {
        do {
            guard let request = getURLRequest(baseURL: url) else {
                throw HTTPServiceError.badURL
            }
            let (data, response) = try await httpClient.send(request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPServiceError.invalidResponse
            }
            guard httpResponse.statusCode == 200 else {
                throw HTTPServiceError.serviceNotFound
            }
            let userData = try httpClient.decode(type: CarArticleData.self, from: data)
            return userData
        } catch {
            print("httpclient error: ", error.localizedDescription)
            throw error
        }
    }
    
    func transactionList() async throws -> CarArticleData {
        guard let request = getURLRequest(baseURL: url) else {
            throw HTTPServiceError.badURL
        }
        do {
            let carArticle: CarArticleData = try await httpClient.load(request)
            return carArticle
        } catch {
            throw error
        }
    }
}

extension MockAPIClient {
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
