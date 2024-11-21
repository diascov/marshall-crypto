// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    defaultLocalization: "en",
    platforms: [
      .iOS(.v18),
    ],
    products: [
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "11.5.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", exact: "8.0.0")
    ],
    targets: [
        .target(name: "Core",
                dependencies: [
                    .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                    .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
                    .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
                ],
                resources: [.process("Resources")]),
        .testTarget(name: "CoreTests", dependencies: ["Core"])
    ]
)
