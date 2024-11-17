//
//  CurrencyViewModel.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation
import Core

@Observable final class CurrencyViewModel {

    // MARK: - Public properties

    let cryptoCurrency: CryptoCurrency

    // MARK: - Init

    init(cryptoCurrency: CryptoCurrency) {
        self.cryptoCurrency = cryptoCurrency
    }
}
