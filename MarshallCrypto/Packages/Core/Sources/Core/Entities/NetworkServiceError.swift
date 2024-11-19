//
//  NetworkServiceError.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

public enum NetworkServiceError {
    case wrongURL
    case wrongResponse
    case custom(Error)
}

// MARK: - LocalizedError

extension NetworkServiceError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .wrongURL: ErrorStrings.wrongUrlTitle.localized()
        case .wrongResponse: ErrorStrings.wrongResponseTitle.localized()
        case .custom(let error): error.localizedDescription
        }
    }

    public var failureReason: String? {
        switch self {
        case .wrongURL: ErrorStrings.wrongUrlMessage.localized()
        case .wrongResponse: ErrorStrings.wrongResponseMessage.localized()
        case .custom(let error): error.localizedDescription
        }
    }
}
