//
//  CryptoCurrenciesListViewModel.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation
import Core

@MainActor @Observable final class CryptoCurrenciesListViewModel {

    // MARK: - Public properties

    var overlayType: CurrenciesListOverlayType? {
        if isInitialLoad {
            .progress
        } else if cryptoCurrencies.isEmpty {
            .contentUnavailable
        } else if searchedCryptoCurrencies.isEmpty {
            .searchContentUnavailable
        } else {
            nil
        }
    }

    var shouldShowPricesToggle: Bool {
        !cryptoCurrencies.isEmpty
    }

    var shouldShowPricesInSEK: Bool {
        didSet {
            guard shouldShowPricesInSEK != oldValue else { return }

            Task {
                updateSelectedCurrency()
            }
        }
    }

    var searchedCryptoCurrencies: [CryptoCurrency] {
        searchText.isEmpty ? cryptoCurrencies : cryptoCurrencies.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var isPresentedAlert = false
    var searchText = ""
    var isLoadingConversionRate = false
    private(set) var isInitialLoad = true
    private(set) var error: NetworkServiceError?
    private(set) var selectedCurrency: Currency
    private(set) var conversionRate: ConversionRate?

    let titleText = CryptoCurrenciesListStrings.title.localized
    let okText = CommonStrings.ok.localized
    let contentUnavailableTitleText = CryptoCurrenciesListStrings.contentUnavailableTitle.localized
    let contentUnavailableMessageText = CryptoCurrenciesListStrings.contentUnavailableMessage.localized
    let pricesCurrencyToggleText = CryptoCurrenciesListStrings.pricesCurrencyToggle.localized

    // MARK: - Private propertries

    private var cryptoCurrencies: [CryptoCurrency] = []
    private let networkService: NetworkServiceAPI

    // MARK: - Init

    init(networkService: NetworkServiceAPI = NetworkService()) {
        self.networkService = networkService

        let currency = Currency(rawValue: UserDefaultsController.stringValue(for: .selectedCurrency) ?? "") ?? .usd

        self.selectedCurrency = currency
        self.shouldShowPricesInSEK = currency == .sek
    }
}

// MARK: - Public

extension CryptoCurrenciesListViewModel {

    func getCurrenciesList() async {
        defer {
            isInitialLoad = false
            isPresentedAlert = error != nil
        }

        error = nil

        do {
            cryptoCurrencies = try await networkService.getCryptoCurrenciesList()
        } catch {
            self.error = error as? NetworkServiceError
        }
    }

    func getConversionRate() async {
        defer {
            isLoadingConversionRate = false
            isPresentedAlert = error != nil
        }

        guard conversionRate == nil else { return }

        isLoadingConversionRate = true

        do {
            conversionRate = try await networkService.getConversionRate()
        } catch {
            self.error = error as? NetworkServiceError
        }
    }
}

// MARK: - Private

private extension CryptoCurrenciesListViewModel {

    func updateSelectedCurrency() {
        selectedCurrency = shouldShowPricesInSEK ? .sek : .usd
        UserDefaultsController.set(selectedCurrency.rawValue, forKey: .selectedCurrency)
    }
}

// MARK: - Models

extension CryptoCurrenciesListViewModel {

    enum CurrenciesListOverlayType {
        case progress
        case searchContentUnavailable
        case contentUnavailable
    }
}
