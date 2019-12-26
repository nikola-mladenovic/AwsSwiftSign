// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AwsSign",
    products: [.library(name: "AwsSign", targets: ["AwsSign"])],
    dependencies: [.package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.3.0")],
    targets: [.target(name: "AwsSign", dependencies: ["CryptoSwift"], path: "Source")],
    swiftLanguageVersions: [.v5]
)
