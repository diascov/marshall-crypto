//
//  Core+Localization.swift
//  MarshallCrypto
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Foundation
import Core

// MARK: - LocalizedError

extension NetworkServiceError: @retroactive LocalizedError {

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

extension CryptoCurrency.PriceType {

    public var title: String {
        switch self {
        case .high: CryptoCurrencyStrings.priceHigh.localized()
        case .low: CryptoCurrencyStrings.priceLow.localized()
        case .current: CryptoCurrencyStrings.priceCurrent.localized()
        case .dailyChange: CryptoCurrencyStrings.dailyChange.localized()
        }
    }
}
