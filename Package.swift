// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "AwsSign",
    products: [.library(name: "AwsSign", targets: ["AwsSign"])],
    dependencies: [.package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.8.3")],
    targets: [.target(name: "AwsSign", dependencies: ["CryptoSwift"], path: "Source")],
    swiftLanguageVersions: [4]
)
