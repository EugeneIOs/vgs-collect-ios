// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VGSCollectSDK",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "VGSCollectSDK",
            targets: ["VGSCollectSDK"]),
			  .library(
					name: "VGSCollectResources",
					targets: ["VGSCollectResources"]),
			  .library(
					name: "VGSCollectSDK-Light",
					targets: ["VGSCollectSDK-Light"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "VGSCollectSDK",
					  dependencies: [
							.target(name: "VGSCollectResources")
						],
  					exclude: [
							"VGSCollectSDK.h",
	 				]),
			.target(
				name: "VGSCollectSDK-Light",
				dependencies: [
					.target(name: "VGSCollectSDK")
				]),
			.target(
					name: "VGSCollectResources"),
			.testTarget(
            name: "FrameworkTests",
            dependencies: ["VGSCollectSDK", "VGSCollectResources"]
				)
			]
)
