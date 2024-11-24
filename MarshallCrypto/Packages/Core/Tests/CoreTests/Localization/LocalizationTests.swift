//
//  LocalizationTests.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
@testable import Core

struct LocalizationTests {

    @Test
    func localization() {
        assertLocalization(CommonStrings.self)
        assertLocalization(CryptoCurrenciesListStrings.self)
        assertLocalization(CryptoCurrencyStrings.self)
        assertLocalization(ErrorStrings.self)
        assertLocalization(ProfileStrings.self)
    }

    private func assertLocalization<T>(_ localization: T.Type, arguments: CVarArg...) where T : Localizable {
        localization.allCases.forEach {
            let format = String(localized: $0.key, table: $0.tableName, bundle: .module)
            #expect($0.localized(arguments: arguments) == String(format: format, arguments: arguments))
        }
    }
}
