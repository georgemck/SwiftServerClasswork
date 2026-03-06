# 2.4 Creating a ServiceGroup

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Step 4

## Running multiple services together

Now that `configureServer` returns a struct that implements the `Service` protocol, evolve this to use a `ServiceGroup`.
This future-proofs for other services you can add later and also explicitly adds signal handling for graceful shutdowns
and cancellation.

Update `Entrypoint.swift` as follows:

```swift
import Vapor
import ServiceLifecycle

@main
struct Entrypoint {
    static func main() async throws {
        // Create the Vapor application instance
        var application = try await Vapor.Application.make()

        // Configure the server and create the service wrapper
        let serverService = try await configureServer(application)

        // Create service group with graceful shutdown handling
        let services: [Service] = [serverService]
        let serviceGroup = ServiceGroup(
            services: services,
            gracefulShutdownSignals: [.sigint],
            cancellationSignals: [.sigterm],
            logger: application.logger
        )

        // Start the service group and run until shutdown
        try await serviceGroup.run()
    }
}
```

Now that you have a `ServiceGroup` defined and running, wrap it in a `do`/`catch` block for proper error handling.

```swift
import Vapor
import ServiceLifecycle

@main
struct Entrypoint {
    static func main() async throws {
        // Create the Vapor application instance
        let application = try await Vapor.Application.make()

        do {
            // Configure the server and create the service wrapper
            let serverService = try await configureServer(application)

            // Create service group with graceful shutdown handling
            let services: [Service] = [serverService]
            let serviceGroup = ServiceGroup(
                services: services,
                gracefulShutdownSignals: [.sigint],
                cancellationSignals: [.sigterm],
                logger: application.logger
            )

            // Start the service group and run until shutdown
            try await serviceGroup.run()
        } catch {
            // Ensure proper cleanup on startup failure
            try await application.asyncShutdown()
            application.logger.error("Application startup failed", metadata: ["error": "\(error)"])
            exit(1)
        }
    }
}
```

To test this, restart the server and then run the following curl request:

```bash
curl localhost:8080
```

The request should return "`Hello, Server!`"
