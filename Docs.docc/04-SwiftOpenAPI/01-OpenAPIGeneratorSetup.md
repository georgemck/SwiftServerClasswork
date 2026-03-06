# 4.1 OpenAPI Generator setup

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 1

## Adding package dependencies

Update your `Package.swift` file to include the necessary OpenAPI dependencies in the dependencies array:

```swift
.package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
.package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
.package(url: "https://github.com/swift-server/swift-openapi-vapor", from: "1.0.0"),
```

Add the corresponding products to your executable target dependencies:

```swift
.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
.product(name: "OpenAPIVapor", package: "swift-openapi-vapor"),
```

Now run `swift package resolve` to install the packages.
