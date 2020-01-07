// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "AMScrollingNavbar",
  products: [
    .library(
      name: "AMScrollingNavbar",
      targets: ["AMScrollingNavbar"])
  ],
  targets: [
    .target(
      name: "AMScrollingNavbar",
      path: "Source")
  ]
)