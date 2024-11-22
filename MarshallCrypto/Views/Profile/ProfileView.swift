//
//  ProfileView.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-21.
//

import SwiftUI
import Core

struct ProfileView: View {

    // MARK: - Private properties

    @Environment(\.dismiss) private var dismiss
    @Environment(RootViewModel.self) private var rootViewModel
    @State private var viewModel: ProfileViewModel

    // MARK: - Init

    init(viewModel: ProfileViewModel) {
        _viewModel = State(wrappedValue: ProfileViewModel())
    }

    var body: some View {
        content
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image.xmarkCircle
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.accent)
                }
            }
    }
}

// MARK: - Views

private extension ProfileView {

    var content: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            VStack {
                profileImage
                Text(rootViewModel.firebaseUser?.displayName ?? "Dmitrii Iascov")
                    .foregroundStyle(Color.textPrimary)
                Text(rootViewModel.firebaseUser?.email ?? "dmitrii.iascov@gmail.com")
                    .foregroundStyle(Color.textPrimary)
                Spacer()

                Button {
                    viewModel.signOut()
                } label: {
                    Text(viewModel.signOutText)
                }
            }
            .padding(16)
        }
    }

    @ViewBuilder var profileImage: some View {
        AsyncImage(url: rootViewModel.firebaseUser?.photoURL) { image in
            image
                .resizable()
                .frame(width: 60, height: 60)
        } placeholder: {
            Image.personCropCircle
                .resizable()
                .frame(width: 60, height: 60)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(viewModel: ProfileViewModel(networkService: NetworkServiceMock()))
            .environment(RootViewModel(networkService: NetworkServiceMock()))
    }
}
