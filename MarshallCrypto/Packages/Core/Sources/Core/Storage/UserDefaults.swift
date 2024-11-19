//
//  UserDefaults.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

public struct UserDefaultsController {

    public static func set(_ value: Any, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    public static func stringValue(for key: UserDefaultsKey) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }
}

public enum UserDefaultsKey: String {
    case selectedCurrency
    case sortOption
}
