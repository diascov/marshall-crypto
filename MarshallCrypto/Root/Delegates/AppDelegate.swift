//
//  AppDelegate.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-20.
//

import UIKit
import GoogleSignIn

@Observable final class AppDelegate: NSObject {
    
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)

        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }

        return configuration
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
}
