//
//  Error.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/08/06.
//

import Foundation

enum DataError: Error {
    case invalidURL
}

extension DataError: LocalizedError {
    var invalidURL: String? {
        return "Error: Invalid Parameter"
    }
}
