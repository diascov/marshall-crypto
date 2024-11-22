//
//  CryptoCurrencyView.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import SwiftUI
import Core

struct CryptoCurrencyView: View {

    // MARK: - Private properties

    @Environment(RootViewModel.self) private var rootViewModel
    @State private var viewModel: CryptoCurrencyViewModel

    // MARK: - Init

    init(viewModel: CryptoCurrencyViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .navigationTitle(viewModel.titleText)
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        rootViewModel.toggleFavorite(id: viewModel.cryptoCurrencyID)
                    } label: {
                        viewModel.favoriteImage(from: rootViewModel.profile)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.gold)
                    }
                }
            }
    }
}

// MARK: - Views

private extension CryptoCurrencyView {

    var content: some View {
        VStack(spacing: 16) {
            AsyncImage(url: viewModel.imageURL) { image in
                image
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
            } placeholder: {
                Image.photoCircleFill
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
            }
            .padding()

            Text(CryptoCurrencyStrings.lastUpdated.localized(arguments: viewModel.lastUpdated))
                .font(.headline)
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, 16)

            priceItem(priceType: .current)
            priceItem(priceType: .high)
            priceItem(priceType: .low)
            priceItem(priceType: .dailyChange)

            Spacer()
        }
        .background {
            Color.backgroundPrimary
                .ignoresSafeArea()
        }
    }

    func priceItem(priceType: CryptoCurrency.PriceType) -> some View {
        HStack {
            Text("\(priceType.title): ")
                .font(.headline)
            Spacer()
            Text(viewModel.price(priceType: priceType))
        }
        .foregroundStyle(Color.textPrimary)
        .padding(.horizontal, 16)
    }
}

#if DEBUG
#Preview {
    let viewModel = CryptoCurrencyViewModel(cryptoCurrency: .preview0, selectedCurrency: .usd, conversionRate: .preview)
    return NavigationStack {
        CryptoCurrencyView(viewModel: viewModel)
            .environment(RootViewModel(networkService: NetworkServiceMock()))
    }
}
#endif
