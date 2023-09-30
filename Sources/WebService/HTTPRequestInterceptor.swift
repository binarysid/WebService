//
//  File.swift
//  
//
//  Created by Linkon Sid on 9/28/23.
//

import Foundation

final class HTTPRequestInterceptor: URLProtocol, URLSessionDelegate {
    private static var interceptedRequests: Set<URLRequest> = []
    static var headers:[String:String]?

    override class func canInit(with request: URLRequest) -> Bool {
        guard !interceptedRequests.contains(request) else {
            return false
        }
        
//        print("Can init.......")
        guard let url = request.url, let scheme = url.scheme else {
            return false
        }

        guard ["http", "https"].contains(scheme) else {
            return false
        }
        return true // Intercept all requests for this example
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        print("Canonical request.......")
        return request
    }
    
    private func getModifiedRequest() -> URLRequest {
        var modifiedRequest = request
        HTTPRequestInterceptor.headers?.forEach {
            let key = $0.key
            let value = $0.value
            modifiedRequest.addValue(value, forHTTPHeaderField: key)
        }
        return modifiedRequest
    }
    
    private func sendHTTPRequest(_ request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            HTTPRequestInterceptor.interceptedRequests.remove(request)
            // Handle the response and data here
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                self.client?.urlProtocolDidFinishLoading(self)
            }
        }
        task.resume()
    }
    
    override func startLoading() {
//        print("start loading.......")
        let modifiedRequest = self.getModifiedRequest()
        HTTPRequestInterceptor.interceptedRequests.insert(modifiedRequest)
        self.sendHTTPRequest(modifiedRequest)
       
    }

    override func stopLoading() {
//        print("stop loading.......")
    }
}
