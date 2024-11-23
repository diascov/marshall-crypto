//
//  RootViewModel.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-20.
//

import UIKit
import Core
import FirebaseAuth

@MainActor @Observable final class RootViewModel {

    // MARK: - Public properties

    var isAuthenticated: Bool {
        user != nil
    }

    var isPresentedAlert = false
    private(set) var isInitialLoad = true
    private(set) var profile: Profile?
    private(set) var error: NetworkServiceError?
    private(set) var user: Core.User?

    let okText = CommonStrings.ok.localized()

    // MARK: - Private properties

    private let networkService: NetworkServiceAPI

    // MARK: - Init

    init(networkService: NetworkServiceAPI = NetworkService()) {
        self.networkService = networkService
    }
}

// MARK: - Public

extension RootViewModel {

    func retrieveAuthenticatedUser() async {
        user = await networkService.retrieveAuthenticatedUser()
    }

    func authenticate(rootViewController: UIViewController?) async {
        defer {
            isPresentedAlert = error != nil
        }

        do {
            user = try await networkService.authenticate(rootViewController: rootViewController)
        } catch {
            self.error = error as? NetworkServiceError
        }
    }

    func fetchProfile() async {
        defer {
            isInitialLoad = false
        }

        guard let userID = user?.id else { return }

        // Skipping error handling, if there is no profile in database we create one locally
        profile = try? await networkService.fetchProfile(userID: userID)

        if profile == nil {
            profile = Profile(favorites: [])
        }
    }

    func toggleFavorite(id: String) {
        profile?.toggleFavorite(id: id)
    }

    func updateProfile() async {
        guard let profile, let userID = user?.id else { return }

        // Skipping error handling, root view doesn't need to handle updateProfile errors
        try? await networkService.updateProfile(profile, id: userID)
    }

    func signOut() {
        networkService.signOut()
        profile = nil
        user = nil
    }

#if DEBUG
    func authenticateWithTestUser() async {
        user = UserMock()
        profile = .preview
    }
#endif
}
