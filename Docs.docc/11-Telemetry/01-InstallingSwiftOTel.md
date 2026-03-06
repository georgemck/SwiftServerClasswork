# 11.1 Installing Swift OTel

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 1:

## Update Package.swift

Add a package dependency for `swift-otel`. This provides OpenTelemetry instrumentation for logs, metrics, and traces in
your server application.

```swift
...
    dependencies: [
        ...
        .package(url: "https://github.com/swift-otel/swift-otel.git", from: "1.0.0"),
    ]
...
```

Now add a product dependency for the `PollsApp` target. This enables the `OTel` module in your application code for
telemetry tracking.

```swift
...
    targets: [
        .executableTarget(
            name: "PollsApp",
            dependencies: [
                ...
                .product(name: "OTel", package: "swift-otel"),
            ]
        )
    ]
...
```

Run `swift package resolve` to download and integrate the `swift-otel` dependency into your project. This makes the `OTel`
module available for import in your source code.
