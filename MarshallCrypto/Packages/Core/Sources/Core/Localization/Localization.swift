//
//  Localization.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

public protocol Localizable: CaseIterable {
    var rawValue: String { get }
    var key: String.LocalizationValue { get }
    var tableName: String { get }
    func localized(arguments: CVarArg...) -> String
}

public extension Localizable {

    var key: String.LocalizationValue {
        String.LocalizationValue(rawValue)
    }

    var tableName: String {
        String(describing: type(of: self)).replacingOccurrences(of: "Strings", with: "")
    }

    func localized(arguments: CVarArg...) -> String {
        let format = String(localized: key, table: tableName, bundle: .module)

        return String(format: format, arguments: arguments)
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
    case unhandledTitle
    case missingProfileTitle
    case missingProfileMessage
}

public enum CryptoCurrenciesListStrings: String, Localizable {
    case title
    case contentUnavailableTitle
    case contentUnavailableMessage
    case pricesCurrencyToggle
    case currentPrices
    case settings
    case sortBy
    case name
    case rank
    case currentPrice
    case favorites
}

public enum CryptoCurrencyStrings: String, Localizable {
    case dailyChange
    case lastUpdated
    case priceCurrent
    case priceHigh
    case priceLow
}

public enum ProfileStrings: String, Localizable {
    case signOut
}
