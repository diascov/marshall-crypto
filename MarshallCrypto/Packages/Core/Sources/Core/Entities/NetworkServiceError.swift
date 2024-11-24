//
//  NetworkServiceError.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

public enum NetworkServiceError: Error {
    case wrongURL
    case wrongResponse
    case missingProfile

    case custom(Error) // to catch default errors
    case unhandled // placeholder case, there should not be such case in perfect world
}
