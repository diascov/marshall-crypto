//
//  CryptoCurrency.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import SwiftUI

public struct CryptoCurrency: Identifiable, Hashable, Sendable {

    // MARK: - Public properties

    public let id: String
    public let name: String
    public let symbol: String
    public let imageURL: URL?
    public let rank: Int
    public let lastUpdated: Date

    // MARK: - Private properties

    private let price: Price
}

// MARK: - Public

public extension CryptoCurrency {

    var arrowImage: Image {
        switch price.dailyChange {
        case let change where change > 0: .arrowUp
        case let change where change < 0: .arrowDown
        default: .arrowLeftArrowRight
        }
    }

    var arrowColor: Color {
        switch price.dailyChange {
        case let change where change > 0: .green
        case let change where change < 0: .red
        default: .gray
        }
    }

    func price(for priceType: PriceType) -> Float {
        switch priceType {
        case .high: price.high
        case .low: price.low
        case .current: price.current
        case .dailyChange: price.dailyChange
        }
    }
}

// MARK: - Models

private extension CryptoCurrency {

    struct Price: Hashable, Sendable {
        let current: Float
        let high: Float
        let low: Float
        let dailyChange: Float
    }
}

public extension CryptoCurrency {

    enum PriceType {
        case high, low, current, dailyChange

        public var title: String {
            switch self {
            case .high: CryptoCurrencyStrings.priceHigh.localized()
            case .low: CryptoCurrencyStrings.priceLow.localized()
            case .current: CryptoCurrencyStrings.priceCurrent.localized()
            case .dailyChange: CryptoCurrencyStrings.dailyChange.localized()
            }
        }
    }
}

// MARK: - Decodable

extension CryptoCurrency: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case imageURL = "image"
        case rank = "market_cap_rank"
        case lastUpdated = "last_updated"
        case priceCurrent = "current_price"
        case priceHigh = "high_24h"
        case priceLow = "low_24h"
        case priceDailyChange = "price_change_24h"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)

        let imageLink = try container.decode(String.self, forKey: .imageURL)

        imageURL = URL(string: imageLink)
        rank = try container.decode(Int.self, forKey: .rank)

        let lastUpdatedString = try container.decode(String.self, forKey: .lastUpdated)

        lastUpdated = DateFormatter.isoDate(from: lastUpdatedString)

        let priceCurrent = try container.decode(Float.self, forKey: .priceCurrent)
        let priceHigh = try container.decode(Float.self, forKey: .priceHigh)
        let priceLow = try container.decode(Float.self, forKey: .priceLow)
        let priceDailyChange = try container.decode(Float.self, forKey: .priceDailyChange)

        price = Price(current: priceCurrent, high: priceHigh, low: priceLow, dailyChange: priceDailyChange)
    }
}

#if DEBUG
public extension CryptoCurrency {
    static let preview0 = CryptoCurrency(id: "bitcoin",
                                         name: "Bitcoin",
                                         symbol: "btc",
                                         imageURL: URL(string: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"),
                                         rank: 3,
                                         lastUpdated: Date(),
                                         price: CryptoCurrency.Price(current: Float.random(in: 1000...999999), high: 1000.8393123, low: 50.3232, dailyChange: 0))
    static let preview1 = CryptoCurrency(id: "ethereum",
                                         name: "Ethereum",
                                         symbol: "eth",
                                         imageURL: URL(string: "https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628"),
                                         rank: 1,
                                         lastUpdated: Date(),
                                         price: CryptoCurrency.Price(current: Float.random(in: 1000...999999), high: 111.111, low: 11.11, dailyChange: 1111.1111))
    static let preview2 = CryptoCurrency(id: "tether",
                                         name: "Tether",
                                         symbol: "usdt",
                                         imageURL: URL(string: "https://coin-images.coingecko.com/coins/images/325/large/Tether.png?1696501661"),
                                         rank: 2,
                                         lastUpdated: Date(),
                                         price: CryptoCurrency.Price(current: 1.0612271837e-7, high: 131.3213, low: 1.2, dailyChange: 1))
    static let preview3 = CryptoCurrency(id: "solana",
                                         name: "Solana",
                                         symbol: "sol",
                                         imageURL: URL(string: "https://coin-images.coingecko.com/coins/images/4128/large/solana.png?1718769756"),
                                         rank: 4,
                                         lastUpdated: Date(),
                                         price: CryptoCurrency.Price(current: Float.random(in: 100...999), high: Float.random(in: 100...999), low: Float.random(in: 100...999), dailyChange: Float.random(in: 100...999)))
}
#endif
