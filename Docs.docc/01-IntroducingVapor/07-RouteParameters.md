# 1.7 Route parameters

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

## Implementing route parameters

In this section a component of the path is used to pass in a parameter that Vapor uses in forming the response.

For example, the response to the curl request

```bash
curl localhost:8080/hello/Friend
```

will be "Hello, Friend!" followed by the time. Replace "Friend" with any other name, and that name is used in the
greeting.

Update your code with the following new elements:

- Pass in a string to be used as a parameter in the path.
- Indicate the string parameter by using a colon before the parameter's name in the `get()` method.
- Get the parameter matching this name when making the request.
- Use an optional for the result, in case the name cannot be found.

## Accepting a String parameter

Add a second `get()` inside of `helloRoutes()`.

The path is `/hello/someName` but this time treat the second path component as a parameter. Label your parameter `name`.
The arguments to your `get()` are `"hello", ":name"`. Note the colon.

Thus far, here's your new `get()`.

```swift
private func helloRoutes(_ application: Application) {
  application.get("hello") {_ in
    "Hello, World! It's \(time)."
  }

  application.get("hello", ":name") { // note ":name" for a parameter named name
    // not complete yet
  }
}
```

Retrieve a parameter named `name` by inspecting the parameters for your request. Note that this means the closure must
provide a name for the request.

```swift
request.parameters.get("name")
```

The result is an optional because there may be no parameter that corresponds to `name`. You can use the nil coalescing
operator to provide a default.

```swift
private func helloRoutes(_ application: Application) {
  application.get("hello") {_ in
    "Hello, World! It's \(time)."
  }

  application.get("hello", ":name") { request in         // use request to get the parameters
    let name = request.parameters.get("name") ?? "World"
    return "Hello, \(name)! It's \(time)."
  }
}
```

You can use this new route like this:

```bash
curl localhost:8080/hello/Friend
```

The result should be similar to this:

```txt
Hello, Friend! It's 3:46 PM.
```

## Error (optional)

The only way you get "Hello, World!" is if there is no parameter named `name`. In other words, it is a programmer error.

Update your code to see how Vapor sends an error as a response. If the parameter name in the route doesn't match the
name you search for in the handler, you can use `Abort()` to throw an internal server error.

```swift
private func helloRoutes(_ application: Application) {
  application.get("hello") {_ in
    "Hello, World! It's \(time)."
  }

  application.get("hello", ":nameALT") { request in       // parameter name has changed
    guard let name = request.parameters.get("name") else {
      throw Abort(.internalServerError)                   // response is a 500 Internal Server error
    }
    return "Hello, \(name)! It's \(time)."
  }
}
```

Restart the server and enter the following command:

```bash
curl -i localhost:8080/hello/Friend
```

You should see the following result:

```txt
HTTP/1.1 500 Internal Server Error
content-type: application/json; charset=utf-8
content-length: 47
connection: keep-alive
date: Sat, 06 Sep 2025 19:21:10 GMT

{"reason":"Internal Server Error","error":true}
```

Before continuing, change `nameALT` back to `:name`.

```swift
private func helloRoutes(_ application: Application) {
  application.get("hello") {_ in
    "Hello, World! It's \(time)."
  }

  application.get("hello", ":name") { request in   // changed back to :name
    guard let name = request.parameters.get("name") else {
      throw Abort(.internalServerError)
    }
    return "Hello, \(name)! It's \(time)."
  }
}
```

There are two routes that begin with the path component `hello`. In the next section abstract this component and also
use a helper function to combine your two existing routes.
