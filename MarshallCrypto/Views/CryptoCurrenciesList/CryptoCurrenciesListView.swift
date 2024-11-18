//
//  CryptoCurrenciesListView.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import SwiftUI
import Core

struct CryptoCurrenciesListView: View {

    // MARK: - Private properties

    @State private var navigationPath: [NavigationPath] = []
    @State private var viewModel: CryptoCurrenciesListViewModel

    // MARK: - Init

    init(viewModel: CryptoCurrenciesListViewModel = CryptoCurrenciesListViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            currenciesList
                .navigationTitle(viewModel.titleText)
                .navigationDestination(for: NavigationPath.self) { destination in
                    if case .cryptoCurrency(let cryptoCurrency) = destination {
                        CryptoCurrencyView(viewModel: CryptoCurrencyViewModel(cryptoCurrency: cryptoCurrency,
                                                                              selectedCurrency: viewModel.selectedCurrency,
                                                                              conversionRate: viewModel.conversionRate))
                    }
                }
                .taskOnAppear {
                    await viewModel.getCurrenciesList()
                    await viewModel.getConversionRate()
                }
                .refreshable(action: viewModel.getCurrenciesList)
                .searchable(text: $viewModel.searchText)
                .overlay {
                    switch viewModel.overlayType {
                    case .progress: ProgressView()
                    case .searchContentUnavailable: ContentUnavailableView.search
                    case .contentUnavailable: contentUnavailable
                    case .none: EmptyView()
                    }
                }
                .alert(isPresented: $viewModel.isPresentedAlert, error: viewModel.error) { _ in
                    Button(viewModel.okText) { }
                } message: { error in
                    Text(error.failureReason ?? "")
                }
        }
        .tint(Color.textAccent)
    }
}

// MARK: - Views

private extension CryptoCurrenciesListView {

    var currenciesList: some View {
        List {
            Section {
                if viewModel.shouldShowPricesToggle {
                    HStack(spacing: 8) {
                        ProgressView()
                            .opacity(viewModel.isLoadingConversionRate ? 1 : 0)
                        Text(viewModel.pricesCurrencyToggleText)
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Toggle("", isOn: $viewModel.shouldShowPricesInSEK)
                            .tint(Color.textAccent)
                    }
                }
            }
            .listRowBackground(Color.backgroundSecondary)

            Section {
                ForEach(viewModel.searchedCryptoCurrencies) { cryptoCurrency in
                    NavigationLink(value: NavigationPath.cryptoCurrency(cryptoCurrency)) {
                        item(for: cryptoCurrency)
                    }
                }
            }
            .listRowBackground(Color.backgroundSecondary)
        }
        .scrollContentBackground(.hidden)
        .background {
            Color.backgroundPrimary
                .ignoresSafeArea()
        }
    }

    func item(for cryptoCurrency: CryptoCurrency) -> some View {
        HStack(spacing: 16) {
            AsyncImage(url: cryptoCurrency.imageURL) { image in
                image
                    .resizable()
                    .frame(width: 20, height: 20)
            } placeholder: {
                ProgressView()
            }

            ViewThatFits {
                HStack(spacing: 8) {
                    Text(cryptoCurrency.name)
                    Spacer()
                    Text(viewModel.price(cryptoCurrency: cryptoCurrency, priceType: .current))

                }

                VStack(alignment: .leading) {
                    Text(cryptoCurrency.name)
                    Text(viewModel.price(cryptoCurrency: cryptoCurrency, priceType: .current))
                }

            }
            .foregroundStyle(Color.textPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
        }
    }

    var contentUnavailable: some View {
        ContentUnavailableView(viewModel.contentUnavailableTitleText,
                               systemImage: "coloncurrencysign.arrow.trianglehead.counterclockwise.rotate.90",
                               description: Text(viewModel.contentUnavailableMessageText))
    }
}

#if DEBUG
#Preview {
    struct NetworkServiceMock: NetworkServiceAPI {

        func getCryptoCurrenciesList() async throws -> [CryptoCurrency] {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return [.preview0, .preview1, .preview2].shuffled()
        }
        
        func getConversionRate() async throws -> ConversionRate {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return .preview
        }
    }

    let viewModel = CryptoCurrenciesListViewModel(networkService: NetworkServiceMock())

    return CryptoCurrenciesListView(viewModel: viewModel)
        .environment(\.locale, Locale(identifier: "sv_SE"))
}
#endif
