//
//  CryptoCurrencyViewModel.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import SwiftUI
import Core

@MainActor @Observable final class CryptoCurrencyViewModel {

    // MARK: - Public properties

    var titleText: String {
        cryptoCurrency.symbol.uppercased()
    }

    var lastUpdated: String {
        DateFormatter.isoString(from: cryptoCurrency.lastUpdated)
    }

    var imageURL: URL? {
        cryptoCurrency.imageURL
    }

    var cryptoCurrencyID: String {
        cryptoCurrency.id
    }

    // MARK: - Private properties

    private let cryptoCurrency: CryptoCurrency
    private let selectedCurrency: Currency
    private let conversionRate: ConversionRate?

    // MARK: - Init

    init(cryptoCurrency: CryptoCurrency, selectedCurrency: Currency, conversionRate: ConversionRate?) {
        self.cryptoCurrency = cryptoCurrency
        self.selectedCurrency = selectedCurrency
        self.conversionRate = conversionRate
    }
}

// MARK: - Public

extension CryptoCurrencyViewModel {

    func price(priceType: CryptoCurrency.PriceType) -> String {
        CurrencyFormatter.price(value: cryptoCurrency.price(for: priceType), in: selectedCurrency, conversionRate: conversionRate)
    }

    func favoriteImage(from profile: Profile?) -> Image {
        guard let profile else { return .star }

        return profile.isFavorite(cryptoCurrency: cryptoCurrency) == true ? .starFill : .star
    }
}
