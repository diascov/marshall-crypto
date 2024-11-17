//
//  CurrencyView.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import SwiftUI

struct CurrencyView: View {

    @State private var viewModel: CurrencyViewModel

    init(viewModel: CurrencyViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        Color.red
    }
}
