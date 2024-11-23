//
//  User+.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-23.
//

import FirebaseAuth

// Protocol is created to mock FirebaseAuth.User and tests purposes
public protocol User {
    var id: String { get }
    var name: String? { get }
    var emailAddress: String? { get }
    var imageURL: URL? { get }
}

extension FirebaseAuth.User: User {
    public var id: String { uid }
    public var name: String? { displayName }
    public var emailAddress: String? { email }
    public var imageURL: URL? { photoURL }
}

#if DEBUG
public struct UserMock: User {

    public let id: String
    public var name: String?
    public var emailAddress: String?
    public var imageURL: URL?

    public init(id: String = "test_user",
                name: String? = "Test User",
                emailAddress: String? = "test@test.com",
                imageURL: URL? = URL(string: "https://media.wired.com/photos/59094a0ad8c8646f38eef2ae/master/pass/rainbow-sq.jpg")) {
        self.id = id
        self.name = name
        self.emailAddress = emailAddress
        self.imageURL = imageURL
    }
}
#endif
