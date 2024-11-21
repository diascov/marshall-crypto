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
    case missingProfile

    case custom(Error) // to catch default errors
    case unhandled // placeholder case, there should not be such case in perfect world
}

// MARK: - LocalizedError

extension NetworkServiceError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .wrongURL: ErrorStrings.wrongUrlTitle.localized()
        case .wrongResponse: ErrorStrings.wrongResponseTitle.localized()
        case .missingProfile: ErrorStrings.missingProfileTitle.localized()
        case .custom(let error): error.localizedDescription
        case .unhandled: ErrorStrings.unhandledTitle.localized()
        }
    }

    public var failureReason: String? {
        switch self {
        case .wrongURL: ErrorStrings.wrongUrlMessage.localized()
        case .wrongResponse: ErrorStrings.wrongResponseMessage.localized()
        case .missingProfile: ErrorStrings.missingProfileMessage.localized()
        case .custom: nil
        case .unhandled: nil
        }
    }
}
