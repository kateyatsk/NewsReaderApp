//
//  NewsAPIError.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 27.04.25.
//

import Foundation
enum NewsAPIError: LocalizedError {
    case invalidBaseURL
    case invalidRequestURL
    case httpStatus(code: Int)
    case noData
    case network(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidBaseURL:
            return "Invalid base URL"
        case .invalidRequestURL:
            return "Failed to build URL"
        case .httpStatus(let code):
            return "HTTP Error \(code)"
        case .noData:
            return "No data"
        case .network(let err):
            return err.localizedDescription
        }
    }
}
