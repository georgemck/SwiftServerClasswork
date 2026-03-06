# 2.1 ServiceLifecycle package

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

## Adding the ServiceLifecycle package

Install the `ServiceLifecycle` package by adding a package dependency to the `Package.swift` file.

```swift
...
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.117.0"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.3.0"),
    ],
...
```

> The `from` parameter uses [Semantic Versioning](http://semver.org) to update to the latest version of the package
> that uses major version 2 and remains compatible with the rest of the project.

Next, add a product dependency to the `PollsApp` executable target:

```swift
...
        .executableTarget(
            name: "PollsApp",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
            ]
        )
...
```

Now run `swift package resolve`. The `ServiceLifecycle` package is ready for use.
