# 1.3 Installing Vapor

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

## Adding Vapor dependencies

Select `Package.swift`. We're going to modify it in two ways to import Vapor and all of its dependencies.

### Package dependency

Add Vapor as a dependency of the `PollsApp` package. In order for the executable to have access to Vapor, specify where
the package should find Vapor and which version it should use.

So that you use a recent version of Vapor, agree to use version 4.117.0 or later.

Open the `Package.swift` file and add a package dependency for Vapor.

```swift
// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "PollsApp",
    platforms: [.macOS(.v26)],
    dependencies: [
        .package(
            url: "https://github.com/vapor/vapor.git",
            from: "4.117.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "PollsApp"
        )
    ]
)
```

This is a necessary step. Save the file and you may notice there's a flurry of activity as the package for Vapor is
downloaded, as are the packages for all of its dependencies.

While this work is being done, add the dependency for the target.

### Target dependency

It's easy to feel that you're performing an unnecessary step here, but many packages contain multiple targets and not
all of them depend on the same packages.

So you also have to specify that the `PollsApp` target depends on Vapor.

Add a second parameter to the `executableTarget()` call. Here you specify that the target is dependent on the product
named Vapor in the package `vapor`.

```swift
// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "PollsApp",
    platforms: [.macOS(.v26)],
    dependencies: [
        .package(
            url: "https://github.com/vapor/vapor.git",
            from: "4.117.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "PollsApp",
            dependencies: [
                .product(
                    name: "Vapor",
                    package: "vapor"
                )
            ]
        )
    ]
)
```

## Download and Install

The packages begin downloading as soon as you save the file with the package dependencies.

You can force this process with `swift package clean` followed by `swift build`.

This process creates a `Package.resolved` file in your project directory that lists all packages that are now available.

Look inside of `.build`, in the checkouts and repositories folders. This folder is included in the `.gitignore` file.

Now you can use Vapor in your application.
