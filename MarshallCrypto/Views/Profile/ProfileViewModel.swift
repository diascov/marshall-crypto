//
//  ProfileViewModel.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-21.
//

import Foundation
import Core

@MainActor @Observable final class ProfileViewModel {

    // MARK: - Public properties

    let signOutText = ProfileStrings.signOut.localized()

    // MARK: - Private properties

    private let networkService: NetworkServiceAPI

    // MARK: - Init

    init(networkService: NetworkServiceAPI = NetworkService()) {
        self.networkService = networkService
    }
}

// MARK: - Public

extension ProfileViewModel {

    func signOut() {
        networkService.signOut()
    }
}
