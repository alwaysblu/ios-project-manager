//
//  DataError.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/08/05.
//

import Foundation

enum DataError: Error {
    case invalidURL
    case invalidData
    case statusCode
    case invalidResponse
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Error: Invalid URL"
        case .invalidData:
            return "Error: Invalid Data."
        case .statusCode:
            return "Error: Status code is not between 200 and 299 ."
        case .invalidResponse:
            return "Error: Invalid Response."
        }
    }
}
