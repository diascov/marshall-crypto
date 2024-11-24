//
//  ConversionRate.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

public struct ConversionRate: Sendable, Equatable {
    let rates: [Currency: Float]
}

// MARK: - Decodable

extension ConversionRate: Decodable {

    enum CodingKeys: String, CodingKey {
        case rates = "conversion_rates"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        rates = Dictionary(uniqueKeysWithValues: try container.decode([String: Float].self, forKey: .rates)
            .compactMap {
                guard let currency = Currency(rawValue: $0.key) else { return nil }
                return (currency, $0.value)
            })
    }
}

#if DEBUG
public extension ConversionRate {
    static let preview = ConversionRate(rates: [
        .usd: 1.0,
        .sek: 10.9779
    ])
}
#endif
