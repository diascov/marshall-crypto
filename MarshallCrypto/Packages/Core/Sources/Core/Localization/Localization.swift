//
//  Localization.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

public protocol Localizable {
    var rawValue: String { get }
    func localized(arguments: CVarArg...) -> String
}

public extension Localizable {

    func localized(arguments: CVarArg...) -> String {
        let key = String.LocalizationValue(rawValue)
        let tableName = String(describing: type(of: self)).replacingOccurrences(of: "Strings", with: "")
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
