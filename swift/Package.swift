// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
/*
 This source file is part of the Swift.org open source project
 Copyright 2015 – 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception
 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import PackageDescription

let package = Package(
    name: "SudokuNode",
    products: [
        .library(name: "SudokuTestData", targets: ["SudokuTestData"]),
        .library(name: "SudokuNode", targets: ["SudokuNode"]),
        .library(name: "SudokuData", targets: ["SudokuData"]),
        .executable(name: "Sudoku", targets: ["Sudoku"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "Sudoku",
            dependencies: ["SudokuData","SudokuNode","SudokuTestData"]
            ),
        .target(
            name: "SudokuData",
            dependencies: ["SudokuNode"]
            ),
        .target(
            name: "SudokuNode"
            ),
        .target(
            name: "SudokuTestData"
            ),
    ]
)
