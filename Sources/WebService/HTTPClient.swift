//
//  File.swift
//  
//
//  Created by Linkon Sid on 9/30/23.
//

import Foundation

public class HTTPClient {
    static var networkMonitor = NetworkMonitor()

    static func register(_ defaultHeaders: [String: String]? = nil) {
        HTTPRequestInterceptor.headers = defaultHeaders
        URLProtocol.registerClass(HTTPRequestInterceptor.self)
    }
}
