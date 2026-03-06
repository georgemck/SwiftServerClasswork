# 1.9 Non-string data

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 9

## Receiving non-string data

Suppose you want to pass in a value that is not a String as a path component. There are two basic strategies.

This section considers what happens when you want to consume a type that is easily convertible from a String using `as`.

For example, suppose you want to submit your guess for a number that is randomly chosen between 1 and 10. If your guess
is 3, your curl request might look something like this:

```bash
curl localhost:8080/guess/3
```

## Adding a guess route

Add a `guessRoutes()` function to `Routes.swift` and call it from `routes()`.

Create a path prefix for "guess" in `guessRoutes()`. In the closure, stub out a `get()` method for the path `/guess/3`
using the label `number`.

```swift
import Vapor
import Foundation

func routes(_ application: Application) {
    defaultRoute(application)
    helloRoutes(application)
    guessRoutes(application)   // add new guess routes
} // ...
// Guess Routes
private func guessRoutes(_ application: Application) {  // new guess routes
  application.group("guess") { guess in                 // guess path prefix
    guess.get(":number") { request in                   // route that will take a number
      // not complete
    }
  }
} // ...
```

## Converting a String to an Int

Fetch `number` almost exactly the same as you looked for `name`. The difference is that in addition to there needing to
be a parameter named `number`, that `String` must be convertible to an `Int`.

In this case `number` should be an `Int`. There are two ways for the request to find and convert `number` to an `Int` to
fail.

First, you might not find a parameter named `number`. As you've seen already, that's entirely in your control.

Second, the `String` for the `number` parameter may not be convertible to an `Int`. For now, guard against these with a
simple message.

```swift
// guess functions
private func guessRoutes(_ application: Application) {
  application.group("guess") { guess in
    guess.get(":number") { request in
      guard let number = request.parameters.get("number",  // retrieve number as Int
                                                 as: Int.self) else {
        return "number must be an Int"     // message if you fail
      }
      return "TODO: Process \(number)"     // temp message if you succeed
    }
  }
}
```

Restart the server and run this request:

```bash
curl localhost:8080/guess/327
```

The output should be something like this:

```txt
TODO: Process 327
```

Also try this request:

```bash
curl localhost:8080/guess/Friend
```

You should see the following response:

```txt
number must be an Int
```

## Responding to number

Create a helper method named `respond()` that determines whether or not `number` is between 1 and 10.

If `number` isn't in range, for now, send a response that says this.

If it is, calculate the actual guess and respond with whether or not the caller's guess was correct.

Here's one possible implementation of `respond()`.

```swift
private func respond(to number: Int) -> String {
  guard number>=1 && number<=10 else {
    return "\(number) is not between 1 and 10"
  }
  let actualNumber = Int.random(in: 1...10)
  let reaction = actualNumber == number ? "Great" : "Sorry"
  return "\(reaction), you guessed \(number) the answer was \(actualNumber)."
}
```

Don't forget to call it from the `get()`.

```swift
private func guessRoutes(_ application: Application) {
  application.group("guess") { guess in
    guess.get(":number") { request in
      guard let number = request.parameters.get("number",
                                               as: Int.self) else {
      return "number must be an Int"
    }
    return respond(to: number)             // call respond()
    }
  }
}
```

Run this request:

```bash
curl localhost:8080/guess/3
```

results in something like this:

```txt
Sorry, you guessed 3 the answer was 5
```

Also run the following request:

```bash
% curl localhost:8080/guess/327
```

You should get the following response:

```txt
327 is not between 1 and 10
```

Instead of responding with messages when something goes wrong, in the next section create and return errors using the
`AbortError` protocol.
