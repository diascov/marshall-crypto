//
//  Profile.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-21.
//

public struct Profile: Codable, Sendable {
    private(set) public var favorites: [String]

    public init(favorites: [String]) {
        self.favorites = favorites
    }
}

// MARK: - Public

public extension Profile {

    mutating func toggleFavorite(id: String) {
        if favorites.contains(id) {
            favorites.removeAll { $0 == id }
        } else {
            favorites.append(id)
        }
    }

    func isFavorite(cryptoCurrency: CryptoCurrency) -> Bool {
        favorites.contains(cryptoCurrency.id)
    }
}

#if DEBUG
public extension Profile {
    static let preview = Profile(favorites: ["bitcoin", "solana"])
}
#endif
