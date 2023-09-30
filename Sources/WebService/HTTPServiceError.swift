//
//  File.swift
//  
//
//  Created by Linkon Sid on 30/3/23.
//

public enum HTTPServiceError: Error {
    case serviceNotFound
    case badURL
    case noDataFound
    case invalidResponse
    case invalidJson
    case noInternet
}
