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
    private var httpClient = HTTPClient(timeoutRequestInterval: 25.0)

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
            let carArticle: CarArticleData = try await httpClient.execute(request: request)
            return carArticle
        } catch {
            throw error
        }
    }
    
    func postTransaction() async throws -> Post {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250YWN0X25vIjoiMDE5NDYwOTQzNDIiLCJleHBpcmVzIjoxNzIzOTM5MTk5Ljk5OTk5OX0._7QSeBGQnEbwbHnEsklovO4KbzmpGFbgcfsihYcT_Io"
        guard let request = URLRequestBuilder().createRequestWith(
            baseURL: "https://startrek.v2.ltd/grammar-checker",
            httpMethod: .POST,
            body: ["content": "startrek grammer cheker"],
            bearerToken: token
        ) else {
            throw HTTPServiceError.badURL
        }
        do {
            let postCont: Post = try await httpClient.execute(request: request)
            return postCont
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
