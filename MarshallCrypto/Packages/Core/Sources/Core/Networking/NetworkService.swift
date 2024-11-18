//
//  NetworkService.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

@MainActor public protocol NetworkServiceAPI {
    func getCryptoCurrenciesList() async throws -> [CryptoCurrency]
    func getConversionRate() async throws -> ConversionRate
}

public struct NetworkService: Sendable {

    // MARK: - Private properties

    // Storing hardcoded API keys in the source code
    // is a significant security risk and can lead to potential issues.
    // This approach is only intended for test assignments.
    private let conversionRateAPIKey = "2fdcac3e2dc328dd9ed81450"
    private let currenciesLink = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    private let conversionRateLink = "https://v6.exchangerate-api.com/v6/%@/latest/USD"

    // MARK: - Init

    public init() { }
}

// MARK: - NetworkServiceAPI

extension NetworkService: NetworkServiceAPI {

    public func getCryptoCurrenciesList() async throws -> [CryptoCurrency] {
        let data = try await getData(from: currenciesLink)

        do {
            return try JSONDecoder().decode([CryptoCurrency].self, from: data)
        } catch {
            throw NetworkServiceError.custom(error)
        }
    }

    public func getConversionRate() async throws -> ConversionRate {
        let data = try await getData(from: String(format: conversionRateLink, conversionRateAPIKey))

        do {
            return try JSONDecoder().decode(ConversionRate.self, from: data)
        } catch {
            throw NetworkServiceError.custom(error)
        }
    }
}

// MARK: - Private

private extension NetworkService {

    func getData(from link: String) async throws -> Data {
        guard let url = URL(string: link) else {
            throw NetworkServiceError.wrongURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkServiceError.wrongResponse
        }

        return data
    }
}
