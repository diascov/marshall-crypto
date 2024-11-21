//
//  Profile.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-21.
//

public struct Profile: Codable, Sendable {
    let id: String
    let favorites: [String]

    public init(id: String, favorites: [String]) {
        self.id = id
        self.favorites = favorites
    }
}

#if DEBUG
extension Profile {
    static let preview = Profile(id: "1", favorites: ["bitcoin", "solana"])
}
#endif
