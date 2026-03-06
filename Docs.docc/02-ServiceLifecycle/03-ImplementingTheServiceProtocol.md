# 2.3 Implementing the Service protocol

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

## Using the Service protocol

In this section, you will transform `configureServer` to return a service instead of an application.

First, import the `ServiceLifecycle` framework at the top of the `ServerService.swift` file:

```swift
import Vapor
import ServiceLifecycle

...
```

Then add this implementation to the bottom of the file:

```swift
struct ServerService: Service {
    let application: Application

    func run() async throws {
        try await application.execute()
    }
}
```

In this struct, a Vapor application is wrapped in the `ServiceLifecycle` `run` function so it can be managed by a
`TaskGroup`. This allows your Swift Server application to gracefully handle shutdown.

Next, update the `configureServer` function to return a `ServerService` object instead of an `Application`:

```swift
func configureServer(_ application: Application) async throws -> Service {
    routes(application)
    return ServerService(application: application)
}
```

Finally, return to `Entrypoint.swift` and update the code as follows. You are creating a variable name for your
`ServerService`. Then you run the application using the `run()` method.

```swift
import Vapor

@main
enum Entrypoint {
    static func main() async throws {
        var application = try await Application.make()
        let serverService = try await configureServer(application)
        try await serverService.run()
    }
}
```

To test this, restart the server and then run the following curl request:

```bash
curl localhost:8080
```

The request should return "`Hello, Server!`"
