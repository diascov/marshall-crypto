//
//  RootView.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-20.
//

import SwiftUI
import Core

struct RootView: View {

    // MARK: - Private properties

    @Environment(SceneDelegate.self) private var sceneDelegate
    @State private var viewModel: RootViewModel

    // MARK: - Init

    init(viewModel: RootViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .taskOnAppear {
                await viewModel.retrieveAuthenticatedUser()
                await viewModel.fetchProfile()
            }
            .alert(isPresented: $viewModel.isPresentedAlert, error: viewModel.error) { _ in
                Button(viewModel.okText) { }
            } message: { error in
                Text(error.failureReason ?? "")
            }
            .environment(viewModel)
    }
}

// MARK: - Views

private extension RootView {

    @ViewBuilder var content: some View {
        if viewModel.isAuthenticated {
            CryptoCurrenciesListView(viewModel: CryptoCurrenciesListViewModel())
        } else {
            signInButtons
        }
    }

    var signInButtons: some View {
        ZStack {
            Color.accent
                .ignoresSafeArea()

            if viewModel.isInitialLoad {
                ProgressView()
            } else {
                VStack {
                    Button {
                        let rootViewController = sceneDelegate.window?.rootViewController

                        Task {
                            await viewModel.authenticate(rootViewController: rootViewController)
                            await viewModel.fetchProfile()
                        }
                    } label: {
                        Image.signInWithGoogle
                            .shadow(color: .backgroundSecondary, radius: 4, x: 0, y: 2)
                    }
#if DEBUG
                    Button {
                        Task {
                            await viewModel.authenticateWithTestUser()
                        }
                    } label: {
                        Text("Sign in with test user")
                            .padding()
                            .foregroundStyle(Color.accent)
                            .background(Color.backgroundPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .backgroundSecondary, radius: 4, x: 0, y: 2)
                    }
#endif
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    RootView(viewModel: RootViewModel(networkService: NetworkServiceMock()))
        .environment(SceneDelegate())
}
#endif
