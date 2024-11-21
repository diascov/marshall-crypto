//
//  NetworkService.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import GoogleSignIn

@MainActor public protocol NetworkServiceAPI {
    func retrieveAuthenticatedUser() async -> FirebaseAuth.User?
    func authenticate(rootViewController: UIViewController?) async throws -> FirebaseAuth.User
    func fetchProfile(profileID: String) async throws -> Profile
    func updateProfile(_ profile: Profile) async throws
    func signOut()
    func fetchCryptoCurrenciesList() async throws -> [CryptoCurrency]
    func fetchConversionRate() async throws -> ConversionRate
}

@MainActor public struct NetworkService {

    // MARK: - Private properties

    private let databaseReference: DatabaseReference = {
        let databaseLink = "https://marshall-crypto-default-rtdb.europe-west1.firebasedatabase.app/"

        return Database.database(url: databaseLink).reference()
    }()

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

    public func retrieveAuthenticatedUser() async -> FirebaseAuth.User? {
        await retrieveAuthenticatedFirebaseUser()
    }

    public func authenticate(rootViewController: UIViewController?) async throws -> FirebaseAuth.User {
        let googleUser = try await authenticateGoogle(rootViewController: rootViewController)
        let firebaseUser = try await authenticateFirebase(googleUser: googleUser)

        return firebaseUser
    }

    public func fetchProfile(profileID: String) async throws -> Profile {
        try await withCheckedThrowingContinuation { continuation in
            databaseReference.child(profileID).observeSingleEvent(of: .value) { snapshot, _  in
                do {
                    guard let object = snapshot.value, !(object is NSNull) else {
                        return continuation.resume(throwing: NetworkServiceError.missingProfile)
                    }

                    let data = try JSONSerialization.data(withJSONObject: object)
                    let response = try JSONDecoder().decode(Profile.self, from: data)

                    continuation.resume(returning: response)
                } catch {
                    continuation.resume(throwing: NetworkServiceError.custom(error))
                }
            }
        }
    }

    public func updateProfile(_ profile: Profile) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            databaseReference.child(profile.id).setValue(profile.asDictionary) { error, _ in
                if let error {
                    continuation.resume(throwing: NetworkServiceError.custom(error))
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
        try? Auth.auth().signOut()
    }

    public func fetchCryptoCurrenciesList() async throws -> [CryptoCurrency] {
        let data = try await getData(from: currenciesLink)

        do {
            return try JSONDecoder().decode([CryptoCurrency].self, from: data)
        } catch {
            throw NetworkServiceError.custom(error)
        }
    }

    public func fetchConversionRate() async throws -> ConversionRate {
        let data = try await getData(from: String(format: conversionRateLink, conversionRateAPIKey))

        do {
            return try JSONDecoder().decode(ConversionRate.self, from: data)
        } catch {
            throw NetworkServiceError.custom(error)
        }
    }
}

// MARK: - Google

private extension NetworkService {

    func authenticateGoogle(rootViewController: UIViewController?) async throws -> GIDGoogleUser {
        if let googleUser = await retrieveAuthenticatedGoogleUser() {
            return googleUser
        }

        guard let rootViewController, let clientID = FirebaseApp.app()?.options.clientID else {
            throw NetworkServiceError.unhandled
        }

        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration

        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                if let result {
                    Task {
                        continuation.resume(returning: result.user)
                    }
                } else if let error {
                    continuation.resume(throwing: NetworkServiceError.custom(error))
                } else {
                    continuation.resume(throwing: NetworkServiceError.unhandled)
                }
            }
        }
    }

    func retrieveAuthenticatedGoogleUser() async -> GIDGoogleUser? {
        await withCheckedContinuation { continuation in
            GIDSignIn.sharedInstance.restorePreviousSignIn { result, _ in
                Task {
                    continuation.resume(returning: result)
                }
            }
        }
    }
}

// MARK: - Firebase

private extension NetworkService {

    func authenticateFirebase(googleUser: GIDGoogleUser) async throws -> FirebaseAuth.User  {
        if let firebaseUser = await retrieveAuthenticatedFirebaseUser() {
            return firebaseUser
        }

        guard let idToken = googleUser.idToken?.tokenString else {
            throw NetworkServiceError.unhandled
        }

        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: googleUser.accessToken.tokenString)

        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(with: credentials) { result, error in
                if let result {
                    Task {
                        continuation.resume(returning: result.user)
                    }
                } else if let error {
                    continuation.resume(throwing: NetworkServiceError.custom(error))
                } else {
                    continuation.resume(throwing: NetworkServiceError.unhandled)
                }
            }
        }
    }

    func retrieveAuthenticatedFirebaseUser() async -> FirebaseAuth.User? {
        await withCheckedContinuation { continuation in
            continuation.resume(returning: Auth.auth().currentUser)
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

#if DEBUG
public struct NetworkServiceMock: NetworkServiceAPI {

    public func retrieveAuthenticatedUser() async -> FirebaseAuth.User? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return nil
    }

    public func authenticate(rootViewController: UIViewController?) async throws -> FirebaseAuth.User {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        throw NetworkServiceError.unhandled
    }

    public func fetchProfile(profileID: String) async throws -> Profile {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return .preview
    }

    public func updateProfile(_ profile: Profile) async throws {

    }

    public func signOut() {

    }

    public func fetchCryptoCurrenciesList() async throws -> [CryptoCurrency] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return [.preview0, .preview1, .preview2].shuffled()
    }

    public func fetchConversionRate() async throws -> ConversionRate {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return .preview
    }

    public init() { }
}
#endif
