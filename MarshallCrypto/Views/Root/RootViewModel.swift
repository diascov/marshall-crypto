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
        firebaseUser != nil
    }

    var isPresentedAlert = false
    private(set) var isInitialLoad = true
    private(set) var profile: Profile?
    private(set) var error: NetworkServiceError?
    private(set) var firebaseUser: FirebaseAuth.User?

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
        firebaseUser = await networkService.retrieveAuthenticatedUser()
    }

    func authenticate(rootViewController: UIViewController?) async {
        defer {
            isPresentedAlert = error != nil
        }

        do {
            firebaseUser = try await networkService.authenticate(rootViewController: rootViewController)
        } catch {
            self.error = error as? NetworkServiceError
        }
    }

    func fetchProfile() async {
        defer {
            isInitialLoad = false
        }

        guard let profileID = firebaseUser?.uid else { return }

        // no error handling. If there is no profile in database, we create one locally
        profile = try? await networkService.fetchProfile(profileID: profileID)

        if profile == nil {
            profile = Profile(id: profileID, favorites: [])
        }
    }

    func signOut() {
        networkService.signOut()
        profile = nil
        firebaseUser = nil
    }
}
