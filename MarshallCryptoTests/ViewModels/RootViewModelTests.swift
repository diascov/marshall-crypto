//
//  RootViewModelTests.swift
//  MarshallCryptoTests
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
import Core
import UIKit
@testable import MarshallCrypto

@MainActor struct RootViewModelTests {

    @Test("When retrieving unauthenticated user, isAuthenticated should be false")
    func retrieveUnauthenticatedUser() async {
        let networkServiceMock = NetworkServiceMock()
        networkServiceMock.hasUser = false

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.retrieveAuthenticatedUser()

        #expect(networkServiceMock.didRetrieveAuthenticatedUser == true)
        #expect(sut.isAuthenticated == false)
    }

    @Test("When retrieving authenticated user, isAuthenticated should be true")
    func retrieveAuthenticatedUser() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.retrieveAuthenticatedUser()

        #expect(networkServiceMock.didRetrieveAuthenticatedUser == true)
        #expect(sut.isAuthenticated == true)
    }

    @Test("When authenticating, with unexpected response, isAuthenticated should be false, isPresentedAlert should be true")
    func authenticateWithError() async {
        let networkServiceMock = NetworkServiceMock()
        networkServiceMock.hasUser = false

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.authenticate(rootViewController: UIViewController())

        #expect(networkServiceMock.didAuthenticate == true)
        #expect(sut.isAuthenticated == false)
        #expect(sut.isPresentedAlert == true)
    }

    @Test("When authenticating, with expected response, isAuthenticated should be true, isPresentedAlert should be false")
    func authenticateWithSuccess() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.authenticate(rootViewController: UIViewController())

        #expect(networkServiceMock.didAuthenticate == true)
        #expect(sut.isAuthenticated == true)
        #expect(sut.isPresentedAlert == false)
    }

    @Test("When fetching profile, if user is not authenticated, profile should be nil")
    func fetchProfileWithoutUser() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.fetchProfile()

        #expect(networkServiceMock.didFetchProfile == false)
        #expect(sut.user == nil)
        #expect(sut.profile == nil)
    }

    @Test("When fetching profile, if user is authenticated, profile should not be nil, but it should be freshly created")
    func fetchProfileWithUserWithoutProfile() async {
        let networkServiceMock = NetworkServiceMock()
        networkServiceMock.hasProfile = false

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.authenticate(rootViewController: UIViewController())
        await sut.fetchProfile()

        #expect(networkServiceMock.didAuthenticate == true)
        #expect(networkServiceMock.didFetchProfile == true)
        #expect(sut.user?.id == "test_user")
        #expect(sut.profile != nil)
        #expect(sut.profile?.favorites.isEmpty == true)
    }

    @Test("When fetching profile, if user is authenticated, profile should not be nil and it should contain favorites from response")
    func fetchProfileWithUserWithProfile() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.authenticate(rootViewController: UIViewController())
        await sut.fetchProfile()

        #expect(networkServiceMock.didAuthenticate == true)
        #expect(networkServiceMock.didFetchProfile == true)
        #expect(sut.user?.id == "test_user")
        #expect(sut.profile != nil)
        #expect(sut.profile?.favorites == ["bitcoin", "solana"])
    }

    @Test("When toggling favorite, if user is not authenticated, if profile is not fetched, should not make any actions")
    func toggleFavoriteWithoutUserWithoutProfile() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        sut.toggleFavorite(id: "bitcoin")

        #expect(sut.user == nil)
        #expect(sut.profile == nil)
    }

    @Test("When toggling favorite, if user is authenticated, if profile is not fetched, should not make any actions")
    func toggleFavoriteWithUserWithoutProfile() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.authenticate(rootViewController: UIViewController())
        sut.toggleFavorite(id: "bitcoin")

        #expect(networkServiceMock.didAuthenticate == true)
        #expect(sut.user?.id == "test_user")
        #expect(sut.profile == nil)
    }

    @Test("When toggling favorite, if user is authenticated, if profile is fetched, should update favorites")
    func toggleFavoriesWithUserWithProfile() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.authenticate(rootViewController: UIViewController())
        await sut.fetchProfile()
        sut.toggleFavorite(id: "bitcoin")

        #expect(networkServiceMock.didAuthenticate == true)
        #expect(networkServiceMock.didFetchProfile == true)
        #expect(sut.user?.id == "test_user")
        #expect(sut.profile != nil)
        #expect(sut.profile?.favorites == ["solana"])
    }

    @Test("When updating profile, if user is not authenticated, if profile is not fetched, should not make any actions")
    func updateProfileWithoutUserWithoutProfile() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.updateProfile()

        #expect(networkServiceMock.didUpdateProfile == false)
        #expect(sut.user == nil)
        #expect(sut.profile == nil)
    }

    @Test("When updating profile, if user is authenticated, if profile is not fetched, should not make any actions")
    func updateProfileWithUserWithoutProfile() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.authenticate(rootViewController: UIViewController())
        await sut.updateProfile()

        #expect(networkServiceMock.didAuthenticate == true)
        #expect(networkServiceMock.didUpdateProfile == false)
        #expect(sut.user?.id == "test_user")
        #expect(sut.profile == nil)
    }

    @Test("When updating profile, if user is authenticated, if profile is fetched, should update favorites")
    func updateProfileWithUserWithProfile() async {
        let networkServiceMock0 = NetworkServiceMock()

        let sut0 = RootViewModel(networkService: networkServiceMock0)
        await sut0.authenticate(rootViewController: UIViewController())
        await sut0.fetchProfile()
        await sut0.updateProfile()

        #expect(networkServiceMock0.didAuthenticate == true)
        #expect(networkServiceMock0.didFetchProfile == true)
        #expect(networkServiceMock0.didUpdateProfile == true)
        #expect(sut0.user?.id == "test_user")
        #expect(sut0.profile != nil)

        let networkServiceMock1 = NetworkServiceMock()
        networkServiceMock1.profileMock = Profile(favorites: ["test0", "test1", "test2"])

        let sut1 = RootViewModel(networkService: networkServiceMock1)
        await sut1.authenticate(rootViewController: UIViewController())
        await sut1.fetchProfile()
        await sut1.updateProfile()

        #expect(networkServiceMock1.didAuthenticate == true)
        #expect(networkServiceMock1.didFetchProfile == true)
        #expect(networkServiceMock1.didUpdateProfile == true)
        #expect(sut1.user?.id == "test_user")
        #expect(sut1.profile?.favorites == ["test0", "test1", "test2"])
    }

    @Test("When signing out, if user is not authenticated, if profile is not fetched, should not make any actions")
    func signOutWithoutUserWithoutProfile() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        sut.signOut()

        #expect(networkServiceMock.didSignOut == true)
        #expect(sut.user == nil)
        #expect(sut.profile == nil)
    }

    @Test("When signing out, if user is authenticated, if profile is not fetched, should remove user")
    func signOutWithUserWithoutProfile() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.authenticate(rootViewController: UIViewController())
        sut.signOut()

        #expect(networkServiceMock.didAuthenticate == true)
        #expect(networkServiceMock.didSignOut == true)
        #expect(sut.user == nil)
        #expect(sut.profile == nil)
    }

    @Test("When signing out, if user is authenticated, if profile is not fetched, should remove user and profile")
    func signOutWithUserWithProfile() async {
        let networkServiceMock = NetworkServiceMock()

        let sut = RootViewModel(networkService: networkServiceMock)
        await sut.authenticate(rootViewController: UIViewController())
        await sut.fetchProfile()
        sut.signOut()

        #expect(networkServiceMock.didAuthenticate == true)
        #expect(networkServiceMock.didFetchProfile == true)
        #expect(networkServiceMock.didSignOut == true)
        #expect(sut.user == nil)
        #expect(sut.profile == nil)
    }

    @Test("When authenticating with test user, should set user")
    func authenticateWithTestUser() {
        let sut = RootViewModel()
        sut.authenticateWithTestUser()

        #expect(sut.user?.id == "test_user")
    }
}

// MARK: - Helpers

private class NetworkServiceMock: NetworkServiceAPI {

    var hasUser = true
    var hasProfile = true

    var profileMock: Profile?

    var didRetrieveAuthenticatedUser = false
    var didAuthenticate = false
    var didFetchProfile = false
    var didUpdateProfile = false
    var didSignOut = false

    func retrieveAuthenticatedUser() async -> User? {
        didRetrieveAuthenticatedUser = true

        return hasUser ? UserMock() : nil
    }

    func authenticate(rootViewController: UIViewController?) async throws -> User {
        didAuthenticate = true

        if hasUser {
            return UserMock()
        } else {
            throw NetworkServiceError.unhandled
        }
    }

    func fetchProfile(userID: String) async throws -> Profile {
        didFetchProfile = true

        if hasProfile {
            return profileMock ?? .preview
        } else {
            throw NetworkServiceError.unhandled
        }
    }

    func updateProfile(_ profile: Profile, id: String) async throws {
        didUpdateProfile = true
    }

    func signOut() {
        didSignOut = true
    }

    func fetchCryptoCurrenciesList() async throws -> [CryptoCurrency] {
        throw NetworkServiceError.unhandled
    }

    func fetchConversionRate() async throws -> ConversionRate {
        throw NetworkServiceError.unhandled
    }
}

private struct UserMock: User {

    let id: String
    let name: String?
    let emailAddress: String?
    let imageURL: URL?

    init(id: String = "test_user",
         name: String? = "Test User",
         emailAddress: String? = "test@test.com",
         imageURL: URL? = URL(string: "https://media.wired.com/photos/59094a0ad8c8646f38eef2ae/master/pass/rainbow-sq.jpg")) {
        self.id = id
        self.name = name
        self.emailAddress = emailAddress
        self.imageURL = imageURL
    }
}
