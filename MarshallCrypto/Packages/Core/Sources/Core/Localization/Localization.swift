//
//  Localization.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

public protocol Localizable {
    var rawValue: String { get }
    var localized: String { get }
}

public extension Localizable {
    var localized: String {
        String(localized: String.LocalizationValue(rawValue),
               table: String(describing: type(of: self)).replacingOccurrences(of: "Strings", with: ""),
               bundle: .main)
    }
}

public enum CommonStrings: String, Localizable {
    case ok
}

public enum ErrorStrings: String, Localizable {
    case wrongUrlTitle
    case wrongUrlMessage
    case wrongResponseTitle
    case wrongResponseMessage
}


public enum CryptoCurrenciesListStrings: String, Localizable {
    case title
    case contentUnavailableTitle
    case contentUnavailableMessage
    case pricesCurrencyToggle
}

public enum CryptoCurrencyStrings: String, Localizable {
    case dailyChange
    case lastUpdated
    case priceCurrent
    case priceHigh
    case priceLow
}
