//
//  CurrencyFormatter.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

public struct CurrencyFormatter {

    public static func price(value: Float,
                             in selectedCurrency: Currency,
                             conversionRate: ConversionRate?) -> String {
        let adjustedValue = value * (conversionRate?.rates[selectedCurrency] ?? 1)
        let price = adjustedValue.formatted(.currency(code: selectedCurrency.rawValue))

        switch adjustedValue {
        case -0.01..<0, 0..<0.01:
            return "-"
        default:
            return price
        }
    }
}
