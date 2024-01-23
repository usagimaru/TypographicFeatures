// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NibInstantiater",
	platforms: [
		.macOS(.v11),
		.iOS("15.0"),
	],
    products: [
        .library(
            name: "TypographicFeatures",
            targets: ["TypographicFeatures"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "TypographicFeatures",
            path: "Sources"),
    ],
	swiftLanguageVersions: [.v5]
)
