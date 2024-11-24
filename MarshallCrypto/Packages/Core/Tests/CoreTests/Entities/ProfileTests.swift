//
//  ProfileTests.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
@testable import Core

struct ProfileTests {

    @Test("When toggle favorite, favorites should be updated")
    func toggleFavorite() {
        var sut: Profile = .preview
        sut.toggleFavorite(id: "bitcoin")

        #expect(sut.favorites == ["solana"])

        sut.toggleFavorite(id: "solana")

        #expect(sut.favorites == [])

        sut.toggleFavorite(id: "bitcoin")

        #expect(sut.favorites == ["bitcoin"])
    }

    @Test("When crypto currency is favorite, isFavorite should return true")
    func isFavorite() {
        let sut: Profile = .preview

        #expect(sut.isFavorite(cryptoCurrency: .preview0) == true)
        #expect(sut.isFavorite(cryptoCurrency: .preview1) == false)
        #expect(sut.isFavorite(cryptoCurrency: .preview2) == false)
        #expect(sut.isFavorite(cryptoCurrency: .preview3) == true)
        #expect(sut.isFavorite(cryptoCurrency: .preview4) == false)
    }
}
