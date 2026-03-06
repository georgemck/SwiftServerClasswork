# 1.10 Errors

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

## Implementing errors

Previously, you used `Abort()` to return a response representing an error. Vapor has a protocol named `AbortError` that
makes it easy for you to create custom error types. You must specify the `status` for the error, but you are free to add
other information as well.

In this section create a type that conforms to `AbortError` that includes one error if `number` can't be converted to a
`String` and another error if `number` is an `Int` that is not in the range from 1 to 10.

Add a new file named GuessError.swift to the `PollApps` folder. Begin to stub it out with these two types of errors.

Use an enum with two cases. One case is `notAnInteger`. The other case is `notInRange` and should have an associated
value of type `Int` to capture the guess.

```swift
import Vapor

enum GuessError: AbortError {  // does not yet conform to AbortError
    case notAnInteger
    case notInRange(Int)
}
```

## Conforming to AbortError

`GuessError` does not yet conform to the `AbortError` protocol. At a minimum you need to provide an `HTTPResponseStatus`
named `status` for the `AbortError`.

```swift
import Vapor

enum GuessError: AbortError {
    case notAnInteger
    case notInRange(Int)
}

extension GuessError {
    var status: HTTPResponseStatus {  // this is required for conformance
        switch (self) {
            case .notAnInteger: .badRequest
            case .notInRange: .rangeNotSatisfiable
        }
    }
}
```

`AbortError` also declares properties named `reason` and `identifier` but gives them default values based on the
`status`. You're free to provide your own implementations of these properties. For example, specialize `reason`.

## Providing a reason

You can also provide a `reason`. For `notInRange` the reason includes the value of the guess.

```swift
import Vapor

enum GuessError: AbortError {
    case notAnInteger
    case notInRange(Int)
}

extension GuessError {
    var status: HTTPResponseStatus {
        switch (self) {
            case .notAnInteger: .badRequest
            case .notInRange: .rangeNotSatisfiable
        }
    }

    var reason: String { // this is optional but useful feedback to the caller
        switch(self) {
            case .notAnInteger: "number must be an Int"
            case .notInRange(let guess): "\(guess) is not between 1 and 10"
        }
    }
}
```

## Creating an instance of Abort

As a convenience, create a computed property named `abort` that returns an instance of `Abort` with the appropriate
`status` and `reason`.

```swift
extension GuessError {
    var status: HTTPResponseStatus {
        switch (self) {
            case .notAnInteger: .badRequest
            case .notInRange: .rangeNotSatisfiable
        }
    }

    var reason: String {
        switch(self) {
            case .notAnInteger: "number must be an Int"
            case .notInRange(let guess): "\(guess) is not between 1 and 10"
        }
    }

    var abort: Abort {  // convenience for creating an instance of Abort
        Abort(status, reason: reason)
    }
}
```

Next, use `GuessError` in your guess routes to return the appropriate responses.

## Throwing GuessErrors

You don't need to do much to modify the code in `Routes.swift` to use `GuessError`. Begin by looking at `respond()`.
Instead of returning `"\(number) is not between 1 and 10"` in the `else` block, throw an `Abort` built from
`notInRange`. This also means that the `respond()` signature must add `throws`.

```swift
private func respond(to number: Int) throws -> String {  // added throws
  guard number>=1 && number<=10 else {
    throw GuessError.notInRange(number).abort        // responding with not in range
  }
  let actualNumber = Int.random(in: 1...10)
  let reaction = actualNumber == number ? "Great" : "Sorry"
  return "\(reaction), you guessed \(number) the answer was \(actualNumber)."
}
```

Similarly, update the `guess.get()` to throw an `Abort` built from `notAnInteger`. Also, add a `try` before the call to
`respond()` because it now throws.

```swift
private func guessRoutes(_ application: Application) {
  application.group("guess") { guess in
    guess.get(":number") { request in
      guard let number = request.parameters.get("number",
                                                 as: Int.self) else {
        throw GuessError.notAnInteger.abort  // throw not an integer
      }
      return try respond(to: number)         // add try
    }
  }
}
```

Run the server and test different inputs.

First, use something that can't be converted to an `Int`:

```bash
curl -i localhost:8080/guess/Friend
```

You get a 400 Bad Request (the `notAnInteger` response):

```txt
HTTP/1.1 400 Bad Request
content-type: application/json; charset=utf-8
content-length: 47
connection: keep-alive
date: Sat, 06 Sep 2025 23:21:11 GMT

{"error":true,"reason":"number must be an Int"}
```

Try using an Int that is out of range:

```bash
curl -i localhost:8080/guess/200
```

You should get a 416 (the `notInRange` response):

```txt
HTTP/1.1 416 Request Range Not Satisfied
content-type: application/json; charset=utf-8
content-length: 53
connection: keep-alive
date: Sat, 06 Sep 2025 23:22:24 GMT

{"error":true,"reason":"200 is not between 1 and 10"}
```

Also use an Int that is in range:

```bash
curl localhost:8080/guess/2
```

The response lets you know if you guessed correctly:

```txt
Sorry, you guessed 2 the answer was 7
```

You now have basic error handling, and you have created a simple Vapor application from scratch. In the remaining
sections, learn about other ways to pass information to the server.
