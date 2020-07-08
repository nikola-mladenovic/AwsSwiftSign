# AwsSign - Swift

AwsSign is a Swift library that enables you to sign `URLRequest`s using Signature Version 4 process. More details on this are available from the [AWS documentation](http://docs.aws.amazon.com/general/latest/gr/signature-version-4.html).

<p>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat" alt="Swift 5.2">
    </a>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux-4E4E4E.svg?colorA=EF5138" alt="Platforms iOS | macOS | watchOS | tvOS | Linux">
    </a>
    <a href="https://github.com/apple/swift-package-manager" target="_blank">
        <img src="https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorB=64A5DE" alt="SPM compatible">
    </a>
</p>

This package builds with Swift Package Manager. Ensure you have installed and activated the latest Swift 5.2 tool chain.

## Quick Start

To use AwsSign, modify the Package.swift file and add following dependency:

``` swift
.package(url: "https://github.com/nikola-mladenovic/AwsSwiftSign.git", .branch("master"))
```

Then import the `AwsSign` library into the swift source code:

``` swift
import AwsSign
```

## Usage

The current release provides a `URLRequest` extension, containing `mutating func sign(accessKeyId: String, secretAccessKey: String) throws` method, which you can use on your request instance to perform Signature Version 4 process:

``` swift
var request = URLRequest(url: URL(string: "https://sns.us-east-1.amazonaws.com?Action=Publish&Message=foo")!)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

try! request.sign(accessKeyId: "593ca2ad2782e4000a586d28", secretAccessKey: "ASDI/YZZfLXLna3xEn7JTIJhyH/YZZfLXLna3xEn7JTIJhyH")

// ...
```
