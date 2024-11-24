//
//  CryptoCurrenciesListViewModelTests.swift
//  MarshallCrypto
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
@testable import Core

struct CryptoCurrenciesListViewModelTests {

    @Test("When daily price changes in plus, it should show arrow up image")
    func arrowImageUp() {
        let sut0: CryptoCurrency = .preview1

        #expect(sut0.arrowImage == .arrowUp)

        let sut1: CryptoCurrency = .preview2

        #expect(sut1.arrowImage == .arrowUp)

        let sut2: CryptoCurrency = .preview3

        #expect(sut2.arrowImage == .arrowUp)
    }

    func arrowImageDown() {
        let sut: CryptoCurrency = .preview4

        #expect(sut.arrowImage == .arrowDown)
    }

    func arrowImageLeftRight() {
        let sut: CryptoCurrency = .preview0

        #expect(sut.arrowImage == .arrowLeftArrowRight)
    }
}
