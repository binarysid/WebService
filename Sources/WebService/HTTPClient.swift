//
//  File.swift
//  
//
//  Created by Linkon Sid on 9/30/23.
//

import Foundation

public class HTTPClient {
    private var networkMonitor = NetworkMonitor()
    public static let shared = HTTPClient()
    private var session: URLSession?

    private init() {
        setSession()
    }

    private func setSession() {
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.protocolClasses = [HTTPRequestInterceptor.self]
        session =  URLSession(configuration: sessionConfig)
    }

    public func register(_ defaultHeaders: [String: String]? = nil) {
        HTTPRequestInterceptor.headers = defaultHeaders
    }
}

extension HTTPClient: WebService {
    public func fetch(_ request: URLRequest) async throws -> (Data, URLResponse) {
        guard let session else {
            throw  HTTPServiceError.sessionNotConfigured
        }

        guard self.networkMonitor.isConnected else {
            throw HTTPServiceError.noInternet
        }
        
        return try await session.data(for: request)
    }

    public func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
