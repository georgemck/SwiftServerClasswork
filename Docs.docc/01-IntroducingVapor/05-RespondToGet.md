# 1.5 Respond to GET

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 5

## A GET request for a path

Start with the HTTP method GET.

In this section, write code so that Vapor can respond to a GET request at a specific endpoint.

For example, suppose you want a response to this curl request:

```bash
curl -i localhost:8080/hello/server
```

Run the request in your second terminal and you will get the same 404 error as before.

```txt
HTTP/1.1 404 Not Found
content-type: application/json; charset=utf-8
content-length: 35
connection: keep-alive
date: Sat, 06 Sep 2025 18:06:56 GMT

{"error":true,"reason":"Not Found"}
```

You need to create something that responds to this GET request.

## Creating a `GET` endpoint with get()

The Vapor APIs include the `on()` method. `on()` takes the HTTP method name, the path, and a closure that takes the
request and returns a response.

Instead, use a convenience method, `get()`.

Pass in the path as comma separated Strings.

So `/hello/server/` becomes `"hello", "server"`. The work being done at this endpoint is captured in a trailing closure
that accepts the request.

Here's how to respond to the curl command above by responding with the string "Hello, Server!".

```swift
@main
struct Entrypoint {
    static func main() async throws {
        let application = try await Application.make()
        application.get( "hello", "server") { request in    // use get()
            "Hello, Server!"
        }
        try await application.execute()
    }
}
```

If the server is still running from before, you will need to terminate it and then re-run it to incorporate the code
changes you just made. To terminate it, press Control+C in the terminal where the server process is running. Then run
the package again.

Once the server is running again, send this request:

```bash
curl localhost:8080/hello/server
```

You should see the response:

```txt
Hello, Server!
```

## Cleanup

There are two things you could change with the `get()` method.

The first is that you never use `request` in the closure, so replace `request` with an `_`.

Second, "Hello, Server!" should be the default response at the server, so remove the path components.

```swift
@main
struct Entrypoint {
    static func main() async throws {
        let application = try await Application.make()
        application.get { _ in           // removed path components and request
            "Hello, Server!"
        }
        try await application.execute()
    }
}
```

The `/hello/server/` path is no longer valid. Terminate the server and then re-run it. If you run `curl localhost:8080`
in your second terminal again, now the root returns:

```txt
Hello, Server!
```

In the next section, you will add more routes and do further refactoring so this feels more like a real server
application.
