//
//  File.swift
//  
//
//  Created by Linkon Sid on 23/4/23.
//

import Foundation

extension URLRequest {
    mutating func addHeaders(headers: [String: String]?) -> Self {
        self.allHTTPHeaderFields  = headers
        if let headers = headers {
            for (key, value) in headers {
                self.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return self
    }
}

extension URLComponents {
    mutating func addParams(params: [String: String]?) {
        if let queryParams = params {
            var queryItems: [URLQueryItem] = []
            for (key, value) in queryParams {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            self.queryItems = queryItems
        }
    }
}
