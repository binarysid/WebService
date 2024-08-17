//
//  File.swift
//  
//
//  Created by Linkon Sid on 23/4/23.
//

import Foundation

final class RequestBuilder {
    private var components: URLComponents?
    private var baseURL: String?
    private var headers: [String: String]?
    private var httpMethod: HTTPMethod?
    private var body: [String: Any]?
    public private(set) var request: URLRequest?
}

// MARK: - Builder Components
extension RequestBuilder {
    public func addBearerToken(_ token: String?) -> Self {
        guard let token else { return self }
        if headers == nil {
            headers = [String: String]()
        }
        headers?["Authorization"] = "Bearer \(token)"
        headers?["Content-Type"] = "application/json"
        return self
    }
    
    public func addHttpMethod(_ method: HTTPMethod?) -> Self {
        self.httpMethod = method
        return self
    }
    
    public func addEndPoint(_ url: String) -> Self {
        self.baseURL = url
        return self
    }

    public func addComponents() -> Self {
        guard let base = baseURL, let urlComponent = URLComponents(string: base) else {
            return self
        }
        self.components = urlComponent
        return self
    }

    public func addParam(_ params: [String: String]?) -> Self {
        components?.addParams(params: params)
        return self
    }

    public func addHeader(_ headers: [String: String]?) -> Self {
        self.headers = headers
        return self
    }

    public func addBody(_ body: [String: Any]?) -> Self {
        self.body = body
        return self
    }
    
    public func build() -> URLRequest? {
        guard let url = components?.url else {return nil}
        
        self.request = URLRequest(url: url)
        self.request?.httpMethod = self.httpMethod?.rawValue
        self.request?.allHTTPHeaderFields = self.headers
        
        if let body, let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])  {
            self.request?.httpBody = jsonData
        }

        return request
    }
}
