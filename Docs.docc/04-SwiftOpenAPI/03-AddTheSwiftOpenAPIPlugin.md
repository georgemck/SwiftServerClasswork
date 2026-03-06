# 4.3 Add the Swift OpenAPI plugin

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 3

## Adding the OpenAPI Generator plugin

Add the OpenAPI Generator plugin to your executable target in `Package.swift`:

```swift
...
    .executableTarget(
        name: "PollsApp",
        dependencies: [
            ... // dependencies listed here
        ],
        plugins: [
            .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
        ]
    )
```

## Building with the plugin

Run `swift build` to trigger the OpenAPI Generator plugin. The plugin will:

1. Read your `openapi.yaml` specification file.
2. Process the `openapi-generator-config.yaml` configuration.
3. Generate Swift types and protocols in the build directory.

After you build successfully, you have access to:

- An `APIProtocol` that defines all operations from your OpenAPI spec.
- Generated `Components.Schemas` types for all data models.
- Generated `Operations` types for request and response handling.

The generated `APIProtocol` requires implementation in your application to handle HTTP requests. The next section involves
implementing this protocol to provide actual API functionality.
