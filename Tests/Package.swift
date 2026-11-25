// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "GuidelinesSearchTests",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "gsearchtest",
            targets: [
                "GuidelinesSearchTest",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-tooling/Guidelines.git",
            branch: "master"
        ),
        .package(path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "GuidelinesSearchTest",
            dependencies: [
                .product(name: "GuidelinesSearch", package: "GuidelinesSearch"),
                .product(
                    name: "Guidelines",
                    package: "Guidelines"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [
        .v6,
    ]
)
