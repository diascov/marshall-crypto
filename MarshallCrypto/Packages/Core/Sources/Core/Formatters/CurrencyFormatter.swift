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

        // Always display 2 decimal places
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 8 // Allow up to 8 decimals for very small numbers

        let currencyValue = value * (conversionRate?.rates[selectedCurrency] ?? 1)

        return formatter.string(from: NSNumber(value: currencyValue)) ?? "-"
    }
}
