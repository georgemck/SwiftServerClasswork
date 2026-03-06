# 5.2 Configuring logger

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 2

## Adding a logger to the Vapor application

With `swift-log` installed, configure the Vapor application to use this new logger.

In `Entrypoint.swift`, initialize a new `Logger` at the beginning of the `main` function.

```swift
@main
struct Entrypoint {
    static func main() async throws {
        let logger = Logger(label: "ServerSideSwift")
...
```

Next, pass the logger to the `Vapor.Application.make()` call.

```swift
@main
struct Entrypoint {
    static func main() async throws {
        let logger = Logger(label: "ServerSideSwift")

        // Create the Vapor application instance
        let application = try await Vapor.Application.make(logger: logger)
...
```

Finally, replace all occurrences of `application.logger` with `logger`. `Entrypoint.swift` looks like this when you
finish making the changes:

```swift
import Vapor
import ServiceLifecycle
import Logging

@main
struct Entrypoint {
    static func main() async throws {
        let logger = Logger(label: "ServerSideSwift")

        // Create the Vapor application instance
        let application = try await Vapor.Application.make(logger: logger)

        do {
            // Configure the server and create the service wrapper
            let serverService = try await configureServer(application)

            // Create service group with graceful shutdown handling
            let services: [Service] = [serverService]
            let serviceGroup = ServiceGroup(
                services: services,
                gracefulShutdownSignals: [.sigint],
                cancellationSignals: [.sigterm],
                logger: logger
            )

            // Start the service group and run until shutdown
            try await serviceGroup.run()
        } catch {
            // Ensure proper cleanup on startup failure
            try await application.asyncShutdown()
            logger.error("Application startup failed", metadata: ["error": "\(error)"])
            exit(1)
        }
    }
}
```
