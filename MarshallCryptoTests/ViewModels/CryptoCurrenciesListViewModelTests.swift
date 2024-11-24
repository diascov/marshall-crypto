//
//  CryptoCurrenciesListViewModelTests.swift
//  MarshallCrypto
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
import Core
import UIKit
@testable import MarshallCrypto

@MainActor struct CryptoCurrenciesListViewModelTests {

    @Test("When fetching crypto currencies list, it should be divided by favorites and other")
    func cryptoCurrencies() async {
        let networkServiceMock = NetworkServiceMock()
        
        let sut = CryptoCurrenciesListViewModel(networkService: networkServiceMock)
        await sut.fetchCryptoCurrenciesList()
        sut.sortOption = .name

        #expect(sut.searchedFavoriteCryptoCurrencies(in: .preview) == [.preview0, .preview3])
        #expect(sut.searchedOtherCryptoCurrencies(in: .preview) == [.preview1, .preview2, .preview4])
    }

    func cryptoCurrenciesWithoutResponse() async {
        let networkServiceMock = NetworkServiceMock()
        networkServiceMock.hasCryptoCurrenciesList = false

        let sut = CryptoCurrenciesListViewModel(networkService: networkServiceMock)
        await sut.fetchCryptoCurrenciesList()

        #expect(sut.isPresentedAlert == true)
    }

    @Test("When fetching conversion rate, it should not show alert and store response")
    func conversionRateWithoutResponse() async {
        let networkServiceMock = NetworkServiceMock()
        networkServiceMock.hasConversionRate = false

        let sut = CryptoCurrenciesListViewModel(networkService: networkServiceMock)
        await sut.fetchConversionRate()

        #expect(sut.isPresentedAlert == true)
        #expect(sut.conversionRate == nil)
    }

    @Test("When fetching crypto currencies list, it should be divided by favorites and other, and active search should be applied")
    func cryptoCurrenciesWithActiveSearch() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = CryptoCurrenciesListViewModel(networkService: networkServiceMock)
        await sut.fetchCryptoCurrenciesList()
        sut.searchText = "bit"

        #expect(sut.searchedFavoriteCryptoCurrencies(in: .preview) == [.preview0])

        sut.searchText = "sol"

        #expect(sut.searchedFavoriteCryptoCurrencies(in: .preview) == [.preview3])

        sut.searchText = "ether"

        #expect(sut.searchedOtherCryptoCurrencies(in: .preview) == [.preview1, .preview2])

        sut.searchText = "te"

        #expect(sut.searchedOtherCryptoCurrencies(in: .preview) == [.preview2])
    }

    @Test("When fetching crypto currencies list, it should show specific progress overlay")
    func overlayType() async {
        let networkServiceMock = NetworkServiceMock()

        let sut0 = CryptoCurrenciesListViewModel(networkService: networkServiceMock)

        #expect(sut0.overlayType(profile: .preview) == .progress)

        await sut0.fetchCryptoCurrenciesList()

        #expect(sut0.overlayType(profile: .preview) == nil)

        networkServiceMock.hasCryptoCurrenciesList = false
        let sut1 = CryptoCurrenciesListViewModel(networkService: networkServiceMock)

        #expect(sut1.overlayType(profile: .preview) == .progress)

        await sut1.fetchCryptoCurrenciesList()

        #expect(sut1.overlayType(profile: .preview) == .contentUnavailable)

        sut1.isSearching = true

        #expect(sut1.overlayType(profile: .preview) == .searchContentUnavailable)
    }

    @Test("When show profile is called, it should present profile")
    func showProfile() {
        let networkServiceMock = NetworkServiceMock()

        let sut = CryptoCurrenciesListViewModel(networkService: networkServiceMock)
        sut.showProfile()

        #expect(sut.isPresentedProfile == true)
    }

    @Test("When passing crypto currency and price type, it should show correct values in USD")
    func pricesInUSD() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = CryptoCurrenciesListViewModel(networkService: networkServiceMock)
        await sut.fetchConversionRate()
        sut.shouldShowPricesInSEK = false

        #expect(sut.price(cryptoCurrency: .preview0, priceType: .high) == "101 000,20 US$")
        #expect(sut.price(cryptoCurrency: .preview0, priceType: .low) == "99 000,30 US$")
        #expect(sut.price(cryptoCurrency: .preview0, priceType: .current) == "100 000,10 US$")
        #expect(sut.price(cryptoCurrency: .preview0, priceType: .dailyChange) == "-")
        #expect(sut.price(cryptoCurrency: .preview1, priceType: .high) == "6,66 US$")
        #expect(sut.price(cryptoCurrency: .preview1, priceType: .low) == "4,44 US$")
        #expect(sut.price(cryptoCurrency: .preview1, priceType: .current) == "5,55 US$")
        #expect(sut.price(cryptoCurrency: .preview1, priceType: .dailyChange) == "-")
        #expect(sut.price(cryptoCurrency: .preview2, priceType: .high) == "131,32 US$")
        #expect(sut.price(cryptoCurrency: .preview2, priceType: .low) == "1,20 US$")
        #expect(sut.price(cryptoCurrency: .preview2, priceType: .current) == "-")
        #expect(sut.price(cryptoCurrency: .preview2, priceType: .dailyChange) == "1,00 US$")
        #expect(sut.price(cryptoCurrency: .preview3, priceType: .high) == "2,02 US$")
        #expect(sut.price(cryptoCurrency: .preview3, priceType: .low) == "3,03 US$")
        #expect(sut.price(cryptoCurrency: .preview3, priceType: .current) == "-")
        #expect(sut.price(cryptoCurrency: .preview3, priceType: .dailyChange) == "0,34 US$")
        #expect(sut.price(cryptoCurrency: .preview4, priceType: .high) == "0,90 US$")
        #expect(sut.price(cryptoCurrency: .preview4, priceType: .low) == "0,77 US$")
        #expect(sut.price(cryptoCurrency: .preview4, priceType: .current) == "0,87 US$")
        #expect(sut.price(cryptoCurrency: .preview4, priceType: .dailyChange) == "0,08 US$")
    }

    @Test("When passing crypto currency and price type, with SEK shouldShowPricesInSEK, it should show correct values in SEK")
    func pricesInSEK() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = CryptoCurrenciesListViewModel(networkService: networkServiceMock)
        await sut.fetchConversionRate()
        sut.shouldShowPricesInSEK = true

        #expect(sut.price(cryptoCurrency: .preview0, priceType: .high) == "1 108 770,12 kr")
        #expect(sut.price(cryptoCurrency: .preview0, priceType: .low) == "1 086 815,38 kr")
        #expect(sut.price(cryptoCurrency: .preview0, priceType: .current) == "1 097 791,12 kr")
        #expect(sut.price(cryptoCurrency: .preview0, priceType: .dailyChange) == "-")
        #expect(sut.price(cryptoCurrency: .preview1, priceType: .high) == "73,11 kr")
        #expect(sut.price(cryptoCurrency: .preview1, priceType: .low) == "48,74 kr")
        #expect(sut.price(cryptoCurrency: .preview1, priceType: .current) == "60,93 kr")
        #expect(sut.price(cryptoCurrency: .preview1, priceType: .dailyChange) == "-")
        #expect(sut.price(cryptoCurrency: .preview2, priceType: .high) == "1 441,62 kr")
        #expect(sut.price(cryptoCurrency: .preview2, priceType: .low) == "13,17 kr")
        #expect(sut.price(cryptoCurrency: .preview2, priceType: .current) == "-")
        #expect(sut.price(cryptoCurrency: .preview2, priceType: .dailyChange) == "10,98 kr")
        #expect(sut.price(cryptoCurrency: .preview3, priceType: .high) == "22,18 kr")
        #expect(sut.price(cryptoCurrency: .preview3, priceType: .low) == "33,26 kr")
        #expect(sut.price(cryptoCurrency: .preview3, priceType: .current) == "0,10 kr")
        #expect(sut.price(cryptoCurrency: .preview3, priceType: .dailyChange) == "3,70 kr")
        #expect(sut.price(cryptoCurrency: .preview4, priceType: .high) == "9,93 kr")
        #expect(sut.price(cryptoCurrency: .preview4, priceType: .low) == "8,44 kr")
        #expect(sut.price(cryptoCurrency: .preview4, priceType: .current) == "9,59 kr")
        #expect(sut.price(cryptoCurrency: .preview4, priceType: .dailyChange) == "0,91 kr")
    }

    @Test("When selecting sort option, the list should be sorted accordingly", arguments: CryptoCurrenciesListViewModel.CryptoCurrencySortOption.allCases)
    func sorting(in sortOption: CryptoCurrenciesListViewModel.CryptoCurrencySortOption) async {
        let networkService = NetworkServiceMock()

        let sut = CryptoCurrenciesListViewModel(networkService: networkService)
        await sut.fetchCryptoCurrenciesList()

        sut.sortOption = sortOption

        switch sortOption {
        case .name:
            #expect(sut.searchedFavoriteCryptoCurrencies(in: .preview) == [.preview0, .preview3])
            #expect(sut.searchedOtherCryptoCurrencies(in: .preview) == [.preview1, .preview2, .preview4])
        case .rank:
            #expect(sut.searchedFavoriteCryptoCurrencies(in: .preview) == [.preview3, .preview0])
            #expect(sut.searchedOtherCryptoCurrencies(in: .preview) == [.preview4, .preview1, .preview2])
        case .currentPrice:
            #expect(sut.searchedFavoriteCryptoCurrencies(in: .preview) == [.preview0, .preview3])
            #expect(sut.searchedOtherCryptoCurrencies(in: .preview) == [.preview1, .preview4, .preview2])
        }
    }

    @Test("When in different states, shouldShowComponents should react accordingly")
    func shouldShowComponents() async {
        let networkService0 = NetworkServiceMock()
        networkService0.hasCryptoCurrenciesList = false

        let sut0 = CryptoCurrenciesListViewModel(networkService: networkService0)
        await sut0.fetchCryptoCurrenciesList()

        #expect(sut0.shouldShowComponents == false)

        let networkService1 = NetworkServiceMock()

        let sut1 = CryptoCurrenciesListViewModel(networkService: networkService1)
        await sut1.fetchCryptoCurrenciesList()
        sut1.isSearching = true

        #expect(sut1.shouldShowComponents == false)

        let networkService2 = NetworkServiceMock()

        let sut2 = CryptoCurrenciesListViewModel(networkService: networkService2)
        await sut2.fetchCryptoCurrenciesList()

        #expect(sut2.shouldShowComponents == true)
    }

    @Test("When if different states, shouldShowConversionRateToggle should react accordingly")
    func shouldShowConversionRateToggle() async {
        let networkService0 = NetworkServiceMock()
        networkService0.hasConversionRate = false

        let sut0 = CryptoCurrenciesListViewModel(networkService: networkService0)
        await sut0.fetchConversionRate()

        #expect(sut0.shouldShowConversionRateToggle == false)

        let networkService1 = NetworkServiceMock()
        let sut1 = CryptoCurrenciesListViewModel(networkService: networkService1)
        async let _ = sut1.fetchConversionRate()

        #expect(sut1.shouldShowConversionRateToggle == false)

        let networkService2 = NetworkServiceMock()
        let sut2 = CryptoCurrenciesListViewModel(networkService: networkService2)
        await sut2.fetchConversionRate()

        #expect(sut2.shouldShowConversionRateToggle == true)
    }
}

// MARK: - Helpers

private class NetworkServiceMock: NetworkServiceAPI {

    var hasCryptoCurrenciesList = true
    var hasConversionRate = true

    var didFetchCryptoCurrenciesList = false
    var didFetchConversionRate = false

    func retrieveAuthenticatedUser() async -> User? {
        return nil
    }

    func authenticate(rootViewController: UIViewController?) async throws -> User {
        throw NetworkServiceError.unhandled
    }

    func fetchProfile(userID: String) async throws -> Profile {
        throw NetworkServiceError.unhandled
    }

    func updateProfile(_ profile: Profile, id: String) async throws {
        throw NetworkServiceError.unhandled
    }

    func signOut() {

    }

    func fetchCryptoCurrenciesList() async throws -> [CryptoCurrency] {
        didFetchCryptoCurrenciesList = true

        if hasCryptoCurrenciesList {
            return [.preview0, .preview1, .preview2, .preview3, .preview4]
        } else {
            throw NetworkServiceError.unhandled
        }
    }

    func fetchConversionRate() async throws -> ConversionRate {
        didFetchConversionRate = true

        if hasConversionRate {
            return .preview
        } else {
            throw NetworkServiceError.unhandled
        }
    }
}
