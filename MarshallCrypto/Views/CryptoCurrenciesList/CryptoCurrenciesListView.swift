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

    @Environment(RootViewModel.self) private var rootViewModel
    @State private var navigationPath: [NavigationPath] = []
    @State private var viewModel: CryptoCurrenciesListViewModel

    // MARK: - Init

    init(viewModel: CryptoCurrenciesListViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            content
                .navigationTitle(viewModel.titleText)
                .toolbar {
                    Button {
                        viewModel.showProfile()
                    } label: {
                        Image.personCropCircle
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.accent)
                    }
                }
                .navigationDestination(for: NavigationPath.self) { destination in
                    if case .cryptoCurrency(let cryptoCurrency) = destination {
                        CryptoCurrencyView(viewModel: CryptoCurrencyViewModel(cryptoCurrency: cryptoCurrency,
                                                                              selectedCurrency: viewModel.selectedCurrency,
                                                                              conversionRate: viewModel.conversionRate))
                    }
                }
                .taskOnAppear {
                    await viewModel.fetchCryptoCurrenciesList()
                    await viewModel.fetchConversionRate()
                }
                .refreshable(action: viewModel.fetchCryptoCurrenciesList)
                .searchable(text: $viewModel.searchText, isPresented: $viewModel.isSearching)
                .overlay {
                    switch viewModel.overlayType(profile: rootViewModel.profile) {
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
                .sheet(isPresented: $viewModel.isPresentedProfile) {
                    ProfileView(viewModel: ProfileViewModel())
                }
        }
        .tint(Color.accent)
    }
}

// MARK: - Views

private extension CryptoCurrenciesListView {

    var content: some View {
        List {
            settingsSection
            favoritesCryptoCurrenciesSection
            otherCryptoCurrenciesSection
        }
        .scrollContentBackground(.hidden)
        .background {
            Color.backgroundPrimary
                .ignoresSafeArea()
        }
    }

    @ViewBuilder var settingsSection: some View {
        if viewModel.shouldShowComponents {
            Section {
                currencyToggle
                sortPicker
            } header: {
                Text(viewModel.settingsText)
                    .foregroundStyle(Color.accent)
            }
            .listRowBackground(Color.backgroundSecondary)
        }
    }

    @ViewBuilder var favoritesCryptoCurrenciesSection: some View {
        if viewModel.shouldShowFavoritesSection(in: rootViewModel.profile) {
            Section {
                ForEach(viewModel.searchedFavoriteCryptoCurrencies(in: rootViewModel.profile)) { cryptoCurrency in
                    NavigationLink(value: NavigationPath.cryptoCurrency(cryptoCurrency)) {
                        item(for: cryptoCurrency)
                    }
                }
            } header: {
                Text("FAVS")
                    .foregroundStyle(Color.accent)
            }
            .listRowBackground(Color.backgroundSecondary)
        }
    }

    @ViewBuilder var otherCryptoCurrenciesSection: some View {
        if viewModel.shouldShowOtherSection(in: rootViewModel.profile) {
            Section {
                ForEach(viewModel.searchedOtherCryptoCurrencies(in: rootViewModel.profile)) { cryptoCurrency in
                    NavigationLink(value: NavigationPath.cryptoCurrency(cryptoCurrency)) {
                        item(for: cryptoCurrency)
                    }
                }
            } header: {
                Text(viewModel.currentPricesText)
                    .foregroundStyle(Color.accent)
            }
            .listRowBackground(Color.backgroundSecondary)
        }
    }

    var currencyToggle: some View {
        HStack(spacing: 8) {
            Text(viewModel.pricesCurrencyToggleText)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer()

            if viewModel.shouldShowConversionRateToggle {
                Toggle("", isOn: $viewModel.shouldShowPricesInSEK)
                    .tint(Color.accent)
            } else {
                ProgressView()
            }
        }
    }

    var sortPicker: some View {
        HStack(spacing: 8) {
            Text(viewModel.sortByText)
                .foregroundStyle(Color.textPrimary)
            Spacer()
            Picker("", selection: $viewModel.sortOption) {
                ForEach(CryptoCurrenciesListViewModel.CryptoCurrencySortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .fixedSize()
            .foregroundStyle(Color.textPrimary)
            .tint(Color.accent)
            .pickerStyle(.menu)
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

            cryptoCurrency.arrowImage
                .resizable()
                .frame(width: 8, height: 16)
                .foregroundStyle(cryptoCurrency.arrowColor)

            ViewThatFits {
                HStack(spacing: 8) {
                    Text(cryptoCurrency.name)
                    Spacer()
                    Text(viewModel.price(cryptoCurrency: cryptoCurrency, priceType: .current))
                }

                VStack(alignment: .leading) {
                    Text(cryptoCurrency.name)
                    HStack(spacing: 8) {
                        Text(viewModel.price(cryptoCurrency: cryptoCurrency, priceType: .current))
                    }
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
    let viewModel = CryptoCurrenciesListViewModel(networkService: NetworkServiceMock())
    CryptoCurrenciesListView(viewModel: viewModel)
        .environment(RootViewModel(networkService: NetworkServiceMock()))
}
#endif
