# 5.1 Installing Swift log

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 1

## Updating Package.swift

Add a package dependency for `swift-log`. This provides structured logging capabilities for your server application.

```swift
...
    dependencies: [
        ...
        .package(url: "https://github.com/apple/swift-log", from: "1.5.2"),
    ]
...
```

Now add a product dependency for the `PollsApp` target. This enables the `Logging` module in your application code.

```swift
...
    targets: [
        .executableTarget(
            name: "PollsApp",
            dependencies: [
                ...
                .product(name: "Logging", package: "swift-log"),
            ]
        )
    ]
...
```

Run `swift package resolve` to download and integrate the `swift-log` dependency into your project. This makes the
`Logging` module available for import in your source code.
