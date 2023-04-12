//
//  APIClient.swift
//  GithubUserSearch
//
//  Created by Linkon Sid on 13/3/23.
//

import Foundation

// Generic Client that can be utilized by all the classes/structs that need to fetch data from remote location
public protocol WebService {
    func fetch(_ request: URLRequest) async throws -> (Data, URLResponse)
    func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T
}

// default implementation
extension WebService {
    public func fetch(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            let result = try await URLSession.shared.data(for: request)
            return result
        } catch {
            throw error
        }
    }

    public func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T {
        do {
            let userData = try JSONDecoder().decode(T.self, from: data)
            return userData
        } catch {
            throw error
        }
    }
}
