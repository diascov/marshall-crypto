//
//  CurrencyFormatterTests.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
@testable import Core

struct CurrencyFormatterTests {

    @Test("When passing parameters, it should return correct value")
    func price() {
        #expect(CurrencyFormatter.price(value: 1, in: .usd, conversionRate: nil) == "1,00 US$")
        #expect(CurrencyFormatter.price(value: 1, in: .usd, conversionRate: .preview) == "1,00 US$")
        #expect(CurrencyFormatter.price(value: 1, in: .sek, conversionRate: .preview) == "10,98 kr")
        #expect(CurrencyFormatter.price(value: 50.50, in: .usd, conversionRate: .preview) == "50,50 US$")
        #expect(CurrencyFormatter.price(value: 50.50, in: .sek, conversionRate: .preview) == "554,38 kr")
        #expect(CurrencyFormatter.price(value: 0.50, in: .usd, conversionRate: .preview) == "0,50 US$")
        #expect(CurrencyFormatter.price(value: 0.50, in: .sek, conversionRate: .preview) == "5,49 kr")
        #expect(CurrencyFormatter.price(value: 0.009, in: .usd, conversionRate: .preview) == "-")
        #expect(CurrencyFormatter.price(value: 0.009, in: .sek, conversionRate: .preview) == "0,10 kr")
        #expect(CurrencyFormatter.price(value: 0.009, in: .sek, conversionRate: nil) == "-")
    }
}
