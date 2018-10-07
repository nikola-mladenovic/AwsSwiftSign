// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "AwsSign",
    products: [.library(name: "AwsSign", targets: ["AwsSign"])],
    dependencies: [.package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.12.0")],
    targets: [.target(name: "AwsSign", dependencies: ["CryptoSwift"], path: "Source")],
    swiftLanguageVersions: [.v4_2]
)
