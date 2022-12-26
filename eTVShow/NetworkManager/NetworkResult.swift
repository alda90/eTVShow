//
//  NetworkResult.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation
enum NetworkResult<T> {
    case success(data: T)
    case failure(error: Error)
}

enum NetworkErrorType: LocalizedError {
    case parseUrlFail
    case invalidResponse
    case dataError
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .parseUrlFail:
            return "Cannot initial URL object"
        case .invalidResponse:
            return "Invalid Response"
        case .dataError:
            return "Invalid data"
        case .serverError:
            return "Internal Server Error"
        }
    }
}
