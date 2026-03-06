# 1.4 Using Vapor

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

## Import Vapor

In order to use Vapor, import Vapor at the top of `Entrypoint.swift`.

```swift
import Vapor

@main
enum Entrypoint { // ...
```

## Create an instance of the server

Create an instance of Vapor. If you've used Vapor in the past, the method you used may have been different.

Use the `static` method `make()` as it takes advantage of modern concurrency in Swift.

```swift
@main
enum Entrypoint {
    static func main() {
        let application = Application.make() // not correct yet
    }
}
```

There are two things that aren't quite correct about this code. Address each.

### Async

Creating the Vapor application may take some time so this is an async call. This must be done from an asynchronous
context. Use async for `main()` and await for `make()`.

```swift
@main
enum Entrypoint {
    static func main() async {
        let application = await Application.make() // still not done
    }
}
```

There is still a compiler warning.

### Possible failure

The other issue is that `make()` can fail so it needs to be called with try. You must also label `main()` with throws.

```swift
enum Entrypoint {
    static func main() async throws {
        let application = try await Application.make()
    }
}
```

> Do not run the package yet. It's not quite ready.

## Start the server

You will need to start the server by running `application`. Again, if you've used Vapor in the past you may have used a
different method. The `execute()` method takes advantage of Swift concurrency.

Starting the server can also fail and take some time and requires `try` and `await`.

```swift
import Vapor

@main
enum Entrypoint {
    static func main() async throws {
        let application = try await Application.make()
        try await application.execute()
    }
}
```

Test that `PollsApp` creates and runs a server instance.

## Run the server

In this simple example, when the package is running, it launches and runs a server instance. When you stop running the
package the server instance is gone.

### Test before running

Before starting the server, use curl to visit `localhost:8080`.

Open a terminal and run this command.

```bash
curl localhost:8080
```

Currently there is no server running on 8080 so you should receive something like this:

```txt
curl: (7) Failed to connect to localhost port 8080 after 0 ms:
      Couldn't connect to server
```

### Run the application

Run the package. Wait for the server to start. Building the Vapor application for the first time might take a while.

Once the server runs, you see something like this:

```txt
2025-08-23T10:50:47-0400 notice codes.vapor.application:
[Vapor] Server started on http://127.0.0.1:8080
```

Use curl again. To get a better look at what's going wrong use the `-i` or `--include` option to include the response
headers in the output.

```bash
curl -i localhost:8080
```

The server runs but has no routes, so you get a 404 Not Found response.

```txt
HTTP/1.1 404 Not Found
content-type: application/json; charset=utf-8
content-length: 35
connection: keep-alive
date: Sat, 06 Sep 2025 17:56:08 GMT

{"error":true,"reason":"Not Found"}
```

### Stop the server

To stop the server, stop the running package. If you are running the package in a terminal, use Control+C to stop it.

Execute the curl command again and the response becomes "Couldn't connect to server".

Next, add a route so that you get a successful response from the server.
