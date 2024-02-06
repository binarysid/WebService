//
//  File.swift
//  
//
//  Created by Linkon Sid on 30/3/23.
//
import Foundation

public enum HTTPServiceError: Error {
    case serviceNotFound
    case badURL
    case noDataFound
    case invalidResponse
    case invalidJson
    case noInternet
    case sessionNotConfigured
    case cancelled
    case timeout
}

extension HTTPServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serviceNotFound:
            return "Service Error"
        case .badURL:
            return "URL Error"
        case .noDataFound:
            return "No Data Found"
        case .invalidResponse:
            return "Invalid Response"
        case .invalidJson:
            return "Invalid Response"
        case .noInternet:
            return "No Internet Connection"
        case .sessionNotConfigured:
            return "Session not configured"
        case .cancelled:
            return "Request Cancelled"
        case .timeout:
            return "Request Timeout"
        }
    }
}
