# 2.2 Abstracting a configure service method

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

## Creating a server service

Create a new file named `ServerService.swift`.

In it, create a function named `configureServer`. This function takes in a Vapor application and returns a Vapor
application. For now, mount the routes and return the application.

```swift
import Vapor

func configureServer(_ application: Application) async throws -> Application {
    routes(application)
    return application
}
```

Update the code in `Entrypoint.swift` as follows, to use the new `configureServer` function:

```swift
import Vapor

@main
enum Entrypoint {
    static func main() async throws {
        var application = try await Application.make()
        application = try await configureServer(application)
        try await application.execute()
    }
}
```

You changed `let application` to `var application` because you moved the route mounting code to the `ServerService`
file. You will continue to build upon that in the next section.

To test this, restart the server and then run the following curl request:

```bash
curl localhost:8080
```

The request should return "`Hello, Server!`"

> As you refactor the server, ensure that it works as before. You can use the curl request above to validate the
> application after each change. Run the server in one terminal window and run your curl commands in a second terminal
> window. Typically, you will need to restart the server after making changes to the server code.
