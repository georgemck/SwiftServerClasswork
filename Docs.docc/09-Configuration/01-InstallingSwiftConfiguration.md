# 9.1 Installing Swift Configuration

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 1:

## Update Package.swift

Add a package dependency for `swift-configuration`. This provides configuration management capabilities for your server
application.

```swift
...
    dependencies: [
        ...
        .package(url: "https://github.com/apple/swift-configuration", from: "1.0.0"),
    ]
...
```

Now add a product dependency for the `PollsApp` target. This enables the `Configuration` module in your
application code.

```swift
...
    targets: [
        .executableTarget(
            name: "PollsApp",
            dependencies: [
                ...
                .product(name: "Configuration", package: "swift-configuration"),
            ]
        )
    ]
...
```

Run `swift package resolve` to download and integrate the `swift-configuration` dependency into your project. This makes
the `Configuration` module available for import in your source code.
