//
//  File.swift
//
//
//  Created by Linkon Sid on 9/30/23.
//

import Foundation

public class HTTPClient: NSObject {
    private var networkMonitor = NetworkMonitor()
    private var session: URLSession?
    private let sessionConfig = URLSessionConfiguration.ephemeral
    private var timeoutRequestInterval: Double?
    private var timeoutResourceInterval: Double?
    
    public init(timeoutRequestInterval: Double? = nil, timeoutResourceInterval: Double? = nil) {
        super.init()
        self.timeoutRequestInterval = timeoutRequestInterval
        self.timeoutResourceInterval = timeoutResourceInterval
        createSession()
    }
    
    private func createSession() {
        if let timeoutRequestInterval {
            sessionConfig.timeoutIntervalForRequest = timeoutRequestInterval
        }
        
        if let timeoutResourceInterval {
            sessionConfig.timeoutIntervalForResource = timeoutResourceInterval
        }
        
        sessionConfig.protocolClasses = [HTTPRequestInterceptor.self]
        session =  URLSession(configuration: sessionConfig)
    }
    
    public func register(_ defaultHeaders: [String: String]? = nil) {
        HTTPRequestInterceptor.headers = defaultHeaders
    }
}

extension HTTPClient: WebService {
    public func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        guard let session else {
            throw  HTTPServiceError.sessionNotConfigured
        }
        
        guard self.networkMonitor.isConnected else {
            throw HTTPServiceError.noInternet
        }
        
        do {
            let responseData = try await session.data(for: request)
            return responseData
        } catch {
            if let urlError = error as? URLError, urlError.code == .timedOut {
                throw HTTPServiceError.timeout
            } else {
                throw error
            }
        }
    }
    
    public func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public func decode<T: Decodable>(type: T.Type, from data: [String: Any]) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
    
    public func cancel() {
        session?.invalidateAndCancel()
        createSession()
    }
}
