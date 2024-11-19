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

    var overlayType: CryptoCurrenciesListOverlayType? {
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

    var shouldShowComponents: Bool {
        !cryptoCurrencies.isEmpty && !isSearching
    }

    var shouldShowPricesInSEK: Bool {
        didSet {
            guard shouldShowPricesInSEK != oldValue else { return }

            updateSelectedCurrency()
        }
    }

    var sortOption: CryptoCurrencySortOption {
        didSet {
            guard sortOption != oldValue else { return }

            updateSortOption()
        }
    }

    var searchedCryptoCurrencies: [CryptoCurrency] {
        searchText.isEmpty ? sortedCryptoCurrencies : sortedCryptoCurrencies.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var isPresentedAlert = false
    var searchText = ""
    var isSearching = false
    var isLoadingConversionRate = false
    private(set) var isInitialLoad = true
    private(set) var error: NetworkServiceError?
    private(set) var selectedCurrency: Currency
    private(set) var conversionRate: ConversionRate?

    let titleText = CryptoCurrenciesListStrings.title.localized()
    let okText = CommonStrings.ok.localized()
    let contentUnavailableTitleText = CryptoCurrenciesListStrings.contentUnavailableTitle.localized()
    let contentUnavailableMessageText = CryptoCurrenciesListStrings.contentUnavailableMessage.localized()
    let pricesCurrencyToggleText = CryptoCurrenciesListStrings.pricesCurrencyToggle.localized()
    let currentPricesText = CryptoCurrenciesListStrings.currentPrices.localized()
    let settingsText = CryptoCurrenciesListStrings.settings.localized()
    let sortByText = CryptoCurrenciesListStrings.sortBy.localized()

    // MARK: - Private propertries

    private var sortedCryptoCurrencies: [CryptoCurrency] {
        switch sortOption {
        case .name:
            cryptoCurrencies.sorted { $0.name < $1.name }
        case .rank:
            cryptoCurrencies.sorted { $0.rank < $1.rank }
        case .currentPrice:
            cryptoCurrencies.sorted { $0.price(for: .current) > $1.price(for: .current) }
        }
    }

    private var cryptoCurrencies: [CryptoCurrency] = []
    private let networkService: NetworkServiceAPI

    // MARK: - Init

    init(networkService: NetworkServiceAPI = NetworkService()) {
        self.networkService = networkService

        let currency = Currency(rawValue: UserDefaultsController.stringValue(for: .selectedCurrency) ?? "") ?? .usd
        let sortOption = CryptoCurrencySortOption(rawValue: UserDefaultsController.stringValue(for: .sortOption) ?? "") ?? .name

        self.selectedCurrency = currency
        self.sortOption = sortOption
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

    func price(cryptoCurrency: CryptoCurrency, priceType: CryptoCurrency.PriceType) -> String {
        CurrencyFormatter.price(value: cryptoCurrency.price(for: priceType), in: selectedCurrency, conversionRate: conversionRate)
    }
}

// MARK: - Private

private extension CryptoCurrenciesListViewModel {

    func updateSelectedCurrency() {
        selectedCurrency = shouldShowPricesInSEK ? .sek : .usd
        UserDefaultsController.set(selectedCurrency.rawValue, forKey: .selectedCurrency)
    }

    func updateSortOption() {
        UserDefaultsController.set(sortOption.rawValue, forKey: .sortOption)
    }
}

// MARK: - Models

extension CryptoCurrenciesListViewModel {

    enum CryptoCurrenciesListOverlayType {
        case progress
        case searchContentUnavailable
        case contentUnavailable
    }

    enum CryptoCurrencySortOption: String, Identifiable, CaseIterable {
        case name, rank, currentPrice

        var id: String { rawValue }

        var title: String {
            switch self {
            case .name: CryptoCurrenciesListStrings.name.localized()
            case .rank: CryptoCurrenciesListStrings.rank.localized()
            case .currentPrice: CryptoCurrenciesListStrings.currentPrice.localized()
            }
        }
    }
}
