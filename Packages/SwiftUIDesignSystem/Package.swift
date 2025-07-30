// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIDesignSystem",
    platforms: [
        .iOS(.v14) // Minimum iOS version supported
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftUIDesignSystem",
            targets: ["SwiftUIDesignSystem"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftUIDesignSystem",
            dependencies: [],
            sources: [
                "Color+Extension.swift",
                "Spacing.swift",
                "Typography.swift",
                "Elevation.swift",
                "BorderStyles.swift",
                "LayoutSystem.swift",
                "IconSystem.swift",
                "ThemeSystem.swift",
                "ButtonComponent.swift"
            ]
        ),
        .testTarget(
            name: "SwiftUIDesignSystemTests",
            dependencies: ["SwiftUIDesignSystem"])
    ]
)


