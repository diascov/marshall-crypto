//
//  MarshallCryptoApp.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import SwiftUI
import Firebase
import Core

@main struct MarshallCryptoApp: App {

    // MARK: - Private properties

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    // MARK: - Init

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel())
                .environment(appDelegate)
        }
    }
}
