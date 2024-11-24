//
//  CryptoCurrencyViewModelTests.swift
//  MarshallCrypto
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
import Core
import Foundation
@testable import MarshallCrypto

@MainActor struct CryptoCurrencyViewModelTests {

    @Test("When initialized, it should set the correct properties from crypto currency")
    func texts() {
        let sut = setupSUT()

        #expect(sut.titleText == "BTC")
        #expect(sut.lastUpdated == "Sunday, November 24, 2024 at 1:27 PM")
        #expect(sut.imageURL == URL(string: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"))
        #expect(sut.cryptoCurrencyID == "bitcoin")
    }

    @Test("When switching currencies, prices should be updated", arguments: Currency.allCases)
    func prices(in currency: Currency) {
        let sut = setupSUT(selectedCurrency: currency)

        switch currency {
        case .usd:
            #expect(sut.price(priceType: .high) == "101 000,20 US$")
            #expect(sut.price(priceType: .low) == "99 000,30 US$")
            #expect(sut.price(priceType: .current) == "100 000,10 US$")
            #expect(sut.price(priceType: .dailyChange) == "-")
        case .sek:
            #expect(sut.price(priceType: .high) == "1 108 770,12 kr")
            #expect(sut.price(priceType: .low) == "1 086 815,38 kr")
            #expect(sut.price(priceType: .current) == "1 097 791,12 kr")
            #expect(sut.price(priceType: .dailyChange) == "-")
        }
    }

    @Test("When crypto currency is in profile, image should be star filled")
    func favoriteImage() {
        let sut0 = setupSUT()

        #expect(sut0.favoriteImage(from: nil) == .star)
        #expect(sut0.favoriteImage(from: .preview) == .starFill)

        let sut1 = setupSUT(cryptoCurrency: .preview1)

        #expect(sut1.favoriteImage(from: .preview) == .star)
    }
}

// MARK: - Helpers

private extension CryptoCurrencyViewModelTests {

    func setupSUT(cryptoCurrency: CryptoCurrency = .preview0, selectedCurrency: Currency = .usd) -> CryptoCurrencyViewModel {
        CryptoCurrencyViewModel(cryptoCurrency: cryptoCurrency, selectedCurrency: selectedCurrency, conversionRate: .preview)
    }
}
