// swift-tools-version: 6.0
import PackageDescription

// check.sh が検証する zip をこの位置へ置く。リンク設定は Orbe の linkerSettings と同じ顔ぶれに、
// Orbe では他の依存が持ち込む IOSurface・UniformTypeIdentifiers を足したもの。
let package = Package(
  name: "GhosttyKitVerify",
  platforms: [.macOS(.v14)],
  targets: [
    .binaryTarget(name: "GhosttyKit", path: "GhosttyKit.zip"),
    .executableTarget(
      name: "verify",
      dependencies: ["GhosttyKit"],
      linkerSettings: [
        .linkedFramework("AppKit"),
        .linkedFramework("Metal"),
        .linkedFramework("MetalKit"),
        .linkedFramework("CoreText"),
        .linkedFramework("CoreGraphics"),
        .linkedFramework("QuartzCore"),
        .linkedFramework("CoreVideo"),
        .linkedFramework("Carbon"),
        .linkedFramework("JavaScriptCore"),
        .linkedFramework("IOSurface"),
        .linkedFramework("UniformTypeIdentifiers"),
        .linkedLibrary("stdc++"),
      ]
    ),
  ]
)
