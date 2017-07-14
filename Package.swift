// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "AwsSign",
    products: [.library(name: "AwsSign", targets: ["AwsSign"])],
    dependencies: [.package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .branch("swift4"))],
    targets: [.target(name: "AwsSign", dependencies: ["CryptoSwift"], path: "Source")]
)