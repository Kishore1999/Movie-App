//
//  APIError.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case noResponse
    case decodingError(Error)
    case networkError(Error)
    case httpError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .noResponse:
            return "No response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let statusCode):
            return "Server error with status code: \(statusCode)"
        }
    }
}
