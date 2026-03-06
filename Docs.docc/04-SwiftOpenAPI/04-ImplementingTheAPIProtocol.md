# 4.4 Implementing the API protocol

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 4

## Creating the API handler file

Create a new file called `APIHandler.swift` in the `Sources/PollsApp` directory. This file will contain the implementation
of the generated `APIProtocol`.

Add the following code to the file:

```swift
import Foundation
import OpenAPIRuntime
import OpenAPIVapor
import Vapor

struct APIHandler: APIProtocol {

    func listPolls(_ input: Operations.ListPolls.Input) async throws -> Operations.ListPolls.Output {
        // Create an empty list of polls for now
        let emptyPolls: [Components.Schemas.Poll] = []
        let pageOfPolls = Components.Schemas.PageOfPolls(polls: emptyPolls)

        return .ok(.init(body: .json(pageOfPolls)))
    }
}
```

## Understanding the generated types

OpenAPI Generator creates several important types based on your `openapi.yaml` specification:

- `Operations.ListPolls.Input` and `Operations.ListPolls.Output` for the GET `/polls` endpoint.
- `Operations.CreatePoll.Input` and `Operations.CreatePoll.Output` for the POST `/polls` endpoint.
- `Operations.GetPollDetail.Input` and `Operations.GetPollDetail.Output` for the GET `/polls/{pollId}` endpoint.
- `Components.Schemas.Poll` for the poll data model.
- `Components.Schemas.PageOfPolls` for paginated poll results.
- `Components.Schemas.CreatePollRequest` for poll creation requests.

## Integrating the API handler with routes

Now that you have created the `APIHandler`, you need to integrate it with your Vapor application's routing system. The
OpenAPI Vapor integration provides a seamless way to register your handler's methods as routes.

### Updating the server service

Return to your `ServerService.swift` file and add the `OpenAPIVapor` import statement at the top of the file:

```swift
import Vapor
import ServiceLifecycle
import OpenAPIVapor
```

Now modify your `configureServer(_:)` function to register the `APIHandler`:

```swift
func configureServer(_ application: Application) async throws -> Service {
    // Keep existing route configuration
    routes(application)

    // Create API handler for request processing
    let handler = APIHandler()

    // Register OpenAPI-generated handlers with Vapor transport
    let transport = VaporTransport(routesBuilder: application)
    try handler.registerHandlers(
        on: transport,
        serverURL: Servers.Server1.url(),
        configuration: .init()
    )

    return ServerService(application: application)
}
```

### Understanding the integration

The integration works through these key components:

- **`VaporTransport`**: Bridges OpenAPI-generated code with Vapor's routing system.
- **`handler.registerHandlers(on:serverURL:configuration:)`**: Automatically registers all your `APIProtocol` methods as
  Vapor routes.
- **`Servers.Server1.url()`**: Uses the server URL defined in your `openapi.yaml` specification.

### Route registration

When you call `registerHandlers`, the OpenAPI Vapor integration automatically does the following:

1. Maps your `listPolls` method to `GET /api/polls`.
2. Creates appropriate request/response handling.
3. Handles serialization and deserialization based on your OpenAPI specification.
4. Integrates with Vapor's middleware pipeline.

### Coexisting with existing routes

The OpenAPI routes work alongside your existing Vapor routes defined in `routes(_:)`. Your application responds to both:

- Traditional Vapor routes (such as `/hello` and `/guess`).
- OpenAPI-generated routes (such as `/api/polls`).

## Building and testing

You can test the integration by running your server and making requests to the OpenAPI endpoints:

```bash
# Start your server
swift run

# Test the polls endpoint
curl http://localhost:8080/api/polls
```
