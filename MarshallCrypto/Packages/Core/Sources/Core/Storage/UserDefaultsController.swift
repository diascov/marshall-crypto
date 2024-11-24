//
//  UserDefaults.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

public struct UserDefaultsController {

    public static func set(_ value: Any, forKey key: UserDefaultsKeyProtocol) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    public static func stringValue(for key: UserDefaultsKeyProtocol) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }
}

public protocol UserDefaultsKeyProtocol {
    var rawValue: String { get }
}

public enum UserDefaultsKey: String, UserDefaultsKeyProtocol {
    case selectedCurrency
    case sortOption
}
