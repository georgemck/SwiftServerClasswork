# 1.6 Simple routes

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 6

## Separating out routes

Rather than continuing to add routes to `application` in `main()`, it is more common to create a separate file and
functions where all the routes are defined.

Create a new file named `Routes.swift` in `Sources/PollsApp/`.

Import Vapor and stub out a function named `routes()` in `Routes.swift` that adds all the routes to the application.

Note the `routes()` method must accept the `Application` instance so you can add routes to your Vapor instance.

In other words, here is the code you should use to start working with `Routes.swift`.

```swift
import Vapor

func routes(_ application: Application) {
}
```

## Move the default route

Create a new function named `defaultRoute()` in `Routes.swift`. Copy the `get()` from `Entrypoint.swift` and paste it
into the body of `defaultRoute()`.

Add a call to `defaultRoute()` in the body of `routes()`.

```swift
import Vapor

func routes(_ application: Application) {
    defaultRoute(application)  // adding the route called when there is no path
}

private func defaultRoute(_ application: Application) {
    application.get() { _ in   // the copy of the default route
      "Hello, Server!"
    }
}
```

Open the `Entrypoint.swift` file and add a call to `routes()` in `main()` in between creating and executing the
application. It replaces the previous call to `get()`.

```swift
import Vapor

@main
struct Entrypoint {
  static func main() async throws {
    let application = try await Application.make()
    routes(application)          // here's where you set up your routes
    try await application.execute()
  }
}
```

The app runs as before. The following curl command returns `Hello, Server!`

```bash
curl localhost:8080
```

## A second route

You are about to create several routes that begin with `/hello`, so create a new function called `helloRoutes()` and
call it from `routes()`.

Inside `helloRoutes()`, create a second route at /hello that returns "Hello, World!"

```swift
import Vapor

func routes(_ application: Application) {
    defaultRoute(application)
    helloRoutes(application)  // add hello routes
}

private func defaultRoute(_ application: Application) {
    application.get { _ in
      "Hello, Server!"
    }
}

private func helloRoutes(_ application: Application) {  // container for your /hello routes
  application.get("hello") {_ in                        // /hello returns "Hello, World!"
    "Hello, World!"
  }
}
```

Restart the server, then check both endpoints.

The following curl command results in `Hello, Server!`

```bash
curl localhost:8080
```

The following curl command results in `Hello, World!`

```bash
curl localhost:8080/hello
```

## Calls from within the closures

Remember, this is a Swift app so you can take advantage of `Foundation` and so on. Later in the day you'll call into a
data store, for now, when greeting the world, go ahead and provide the current time.

Import Foundation. You can create a private computed property for the time and use String interpolation in the relevant
`get()`.

```swift
import Vapor
import Foundation  // ...

private func helloRoutes(_ application: Application) {
  application.get("hello") {_ in
    "Hello, World! It's \(time)."  // added a call to time
  }
}

private var time: String {         // private computed property
  Date().formatted(date: .omitted,
                   time: .shortened)
}
```

Restart the server and then run this curl command again:

```bash
curl localhost:8080/hello
```

You get a response like this:

```txt
Hello, World! It's 11:41 AM.
```

Thus far the `get()` methods have not needed information from the `request`. In the next section information is pulled
from the path using route parameters.
