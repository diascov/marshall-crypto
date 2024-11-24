//
//  EncodableTests.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
@testable import Core

struct EncodableTests {

    @Test("When encoding an encodable struct, it should return a dictionary")
    func asDictionary() {
        let sut: Profile = .preview

        #expect(sut.asDictionary["favorites"] as? [String] ?? [] == ["bitcoin", "solana"])
    }
}
