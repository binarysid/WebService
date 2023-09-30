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
