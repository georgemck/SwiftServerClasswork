# 6.1 Configuring Fluent

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 1

## Adding Fluent dependencies

First, ensure that `Package.swift` includes the Fluent dependencies in the dependencies array:

```swift
.package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
.package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
```

Add the corresponding products to the executable target dependencies:

```swift
.product(name: "Fluent", package: "fluent"),
.product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
```

Now run `swift package resolve` to install the packages.
