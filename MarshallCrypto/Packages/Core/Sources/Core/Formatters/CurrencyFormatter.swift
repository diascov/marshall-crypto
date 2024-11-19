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
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = selectedCurrency.rawValue

        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 8

        let currencyValue = value * (conversionRate?.rates[selectedCurrency] ?? 1)

        return formatter.string(from: NSNumber(value: currencyValue)) ?? "-"
    }
}
