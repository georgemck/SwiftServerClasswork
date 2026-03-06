# 1.8 Refactor the code

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

## Path prefix

You can remove the repeated code in a couple of ways.

### Add a path prefix

You have grouped the `get()` methods that use paths that start with /hello into `helloRoutes()`.

Vapor allows you to do more.

Create a path prefix that specifies the path begins with `hello` using the `grouped()` method and then use that path
prefix to remove the repeated path component.

```swift
private func helloRoutes(_ application: Application) {
  let hello = application.grouped("hello")  // create the path prefix hello

  hello.get {_ in      // use hello instead of application and shorten path
    "Hello, World! It's \(time)."
  }

  hello.get(":name") { request in       // use hello and shorten path again
    guard let name = request.parameters.get("name") else {
      throw Abort(.internalServerError)
    }
    return "Hello, \(name)! It's \(time)."
  }
}
```

Run the server and make the same curl calls as before to see the same results.

```bash
curl localhost:8080/hello
curl localhost:8080/hello/Friend
```

There is still some repeated code. Remember, the only way you get the internal server error is if you make an error
with the name of the parameter.

Really, the difference between returning "Hello, World!" and "Hello, Friend!" is whether the caller added a second
path component after `/hello`.

There is still some repeated code. Remember, the only way to get the internal server error is if you make a mistake
in naming the parameter.

To combine the two routes so that you get this behavior, you need a helper method.

Although `greeting()` returns a `String`, declare the type returned by `greeting()` to be some type that conforms to
`ResponseEncodable`. As a result, the `String` will be transformed to an `HTTPResponse`.

Add the `greeting()` function and call it from the two `get()`s.

```swift
private func helloRoutes(_ application: Application) {
    let hello = application.grouped("hello")

    hello.get(use: greeting)                  // use greeting
    hello.get(":name", use: greeting)         // use greeting
}

// add helper method
private func greeting(_ request: Request) -> some ResponseEncodable {
    let name = request.parameters.get("name") ?? "World"
    return "Hello, \(name)! It's \(time)."
}
```

Isn't that nice and clean?

Check that the three endpoints still return correct responses.

### An alternate API for the prefix

There is also a closure-based API for path prefixes. You can use this instead:

```swift
private func helloRoutes(_ application: Application) {
  application.group("hello") { hello in // closure based API
    hello.get(use: greeting)
    hello.get(":name", use: greeting)
  }
}
```

Again, check the endpoints to make sure that they still return correct responses.

Here is the current state of `Routes.swift`:

```swift
import Vapor
import Foundation

func routes(_ application: Application) {
    defaultRoute(application)
    helloRoutes(application)
}
// Default Route
private func defaultRoute(_ application: Application) {
    application.get { _ in
        "Hello, Server!"
    }
}
// Hello Routes
private func helloRoutes(_ application: Application) {
    application.group("hello") { hello in
        hello.get(use: greeting)
        hello.get(":name", use: greeting)
    }
}

// Utilities
private func greeting(_ request: Request) -> some ResponseEncodable {
    let name = request.parameters.get("name") ?? "World"
    return "Hello, \(name)! It's \(time)."
}

private var time: String {
    Date().formatted(
        date: .omitted,
        time: .shortened
    )
}
```

In this section you received a path component as a String. In the next section you see how to receive types that can
be converted from Strings.
