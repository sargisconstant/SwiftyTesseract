// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if !os(Linux)
let dependencies: [PackageDescription.Package.Dependency] = [
  .package(url: "https://github.com/SwiftyTesseract/libtesseract.git", .upToNextMinor(from: "0.2.0")),
]
#else
let dependencies = [PackageDescription.Package.Dependency]()
#endif

#if !os(Linux)
let linkerSettings: [PackageDescription.LinkerSetting] = [
  .linkedLibrary("z"),
  .linkedLibrary("c++")
]
#else
let linkerSettings: [PackageDescription.LinkerSetting] = [
  .linkedLibrary("z"),
  .linkedLibrary("stdc++")
]
#endif

let libraryTarget = PackageDescription.Target.target(
  name: "SwiftyTesseract",
  dependencies: ["libtesseract"],
  linkerSettings: linkerSettings
)

#if !os(Linux)
let targets = [libraryTarget]
#else
let targets: [PackageDescription.Target] = [
  .systemLibrary(
    name: "libtesseract",
    path: "LinuxModules",
    pkgConfig: "tesseract",
    providers: [.apt(["libtesseract-dev", "libleptonica-dev"])]
  ),
  libraryTarget,
]
#endif

let package = Package(
  name: "SwiftyTesseract",
  platforms: [.iOS(.v12), .macOS(.v10_13)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "SwiftyTesseract",
      targets: ["SwiftyTesseract"]),
  ],
//  dependencies: dependencies,
  targets: targets
)
