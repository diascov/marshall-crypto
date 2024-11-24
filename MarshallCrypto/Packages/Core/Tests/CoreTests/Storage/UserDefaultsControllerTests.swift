//
//  UserDefaultsControllerTests.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
@testable import Core

struct UserDefaultsControllerTests {

    @Test("When set string value, it should store value in user defaults and return it if needed")
    func setStringValue() {
        UserDefaultsController.set("test string 0", forKey: UserDefaultsKeyMock.test0)
        UserDefaultsController.set("test string 1", forKey: UserDefaultsKeyMock.test1)

        #expect(UserDefaultsController.stringValue(for: UserDefaultsKeyMock.test0) == "test string 0")
        #expect(UserDefaultsController.stringValue(for: UserDefaultsKeyMock.test1) == "test string 1")
    }
}

// MARK: - Helpers

private enum UserDefaultsKeyMock: String, UserDefaultsKeyProtocol {
    case test0
    case test1
}
