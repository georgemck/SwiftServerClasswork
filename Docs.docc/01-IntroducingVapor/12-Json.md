# 1.12 JSON

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 12

## Decoding JSON

You have passed the guess as part of the path and as a query. In this final section, pass it as JSON data.

Typically, JSON is part of a POST request not a GET because you are using the data to create or update data
instead of to fetch a particular value.

Swift makes it easy to encode and decode JSON using the `Codable` protocol (which includes the `Encodable` and
`Decodable` protocols). Vapor makes it even easier with the `Content` protocol which includes the `Codable` protocol.

Create a new file named `Guess.swift` in `PollsApp`. Add a Vapor import and this simple struct named `Guess` that
conforms to `Content` and contains a single property named `number` of type `Int`.

```swift
import Vapor

struct Guess: Content {
  var number: Int
}
```

The idea is that now if you get a `POST` request that includes JSON data, you can try to decode it into an instance
of `Guess`.

## Decoding and using the JSON

Copy `GuessError.swift` from your step 11 target into your step 12 target so the new route can use it.

Add a new route using `guess.post()` instead of `guess.get()`. This time you ask the `request` for its `content` and
try to decode it into an instance of `Guess`.

That process looks like this:

```swift
try request.content.decode(Guess.self)
```

If this fails to produce a `Guess` instance, throw a `notAnInteger` error. You could introduce a new error for `Guess`
but `notAnInteger` is sufficient for your purposes.

If this successfully produces a `Guess` instance, store `guess.number` in a local variable named `number`. Finally,
check that `number` is in range and respond accordingly.

Fortunately, reuse much of what you've done thus far.

```swift
private func guessRoutes(_ application: Application) {
  application.group("guess") { guess in
  //  skipping the guess.get()s

    guess.post { request in
      var number: Int
      do {
        let guess = try request.content.decode(Guess.self)
        number = guess.number
      }
      catch {
        throw GuessError.notAnInteger.abort
      }
      return try respond(to: number)
    }
  }
}
```

## Testing the POST

Sending a `POST` in `curl` is more complicated. The client would most likely do this work behind the scenes.

Restart the server, then send something that cannot be decoded to a `Guess`:

```bash
curl -i -X POST http://localhost:8080/guess \
-H 'Content-Type: application/json' \
-d '{"number": "seven"}'
```

As expected, you get the `notAnInteger` error:

```txt
HTTP/1.1 400 Bad Request
content-type: application/json; charset=utf-8
content-length: 47
connection: keep-alive
date: Sun, 07 Sep 2025 00:19:00 GMT

{"error":true,"reason":"number must be an Int"}
```

Send something that is out of range.

```bash
curl -i -X POST http://localhost:8080/guess \
-H 'Content-Type: application/json' \
-d '{"number": 75}'
```

You get the out of range error:

```txt
HTTP/1.1 416 Request Range Not Satisfied
content-type: application/json; charset=utf-8
content-length: 52
connection: keep-alive
date: Sun, 07 Sep 2025 00:19:55 GMT

{"error":true,"reason":"75 is not between 1 and 10"}
```

Finally, send a valid value.

```bash
curl -X POST http://localhost:8080/guess \
-H 'Content-Type: application/json' \
-d '{"number": 7}'
```

Because the answer is randomly generated, the result will vary. Most of the time you will see a `Sorry` response:

```txt
Sorry, you guessed 7 the answer was 3.
```

Keep sending the request until the numbers match and you see a `Great` response:

```txt
Great, you guessed 7 the answer was 7.
```

## Wrap up

This is a great place to end the introduction to Swift Server and Vapor. For completeness, here is the final state of
`Routes.swift`:

```swift
import Foundation
import Vapor

func routes(_ application: Application) {
    defaultRoute(application)
    helloRoutes(application)
    guessRoutes(application)
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
// Guess Routes
private func guessRoutes(_ application: Application) {
    application.group("guess") { guess in
        guess.get(":number") { request in
            guard
                let number = request.parameters.get(
                    "number",
                    as: Int.self
                )
            else {
                throw GuessError.notAnInteger.abort
            }
            return try respond(to: number)
        }

        guess.get { request in
            guard let number: Int = request.query["number"] else {
                throw GuessError.notAnInteger.abort
            }
            return try respond(to: number)
        }

        guess.post { request in
            var number: Int
            do {
                let guess = try request.content.decode(Guess.self)
                number = guess.number
            } catch {
                throw GuessError.notAnInteger.abort
            }
            return try respond(to: number)
        }
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

private func respond(to number: Int) throws -> String {
    guard number >= 1 && number <= 10 else {
        throw GuessError.notInRange(number).abort
    }
    let actualNumber = Int.random(in: 1...10)
    let reaction = actualNumber == number ? "Great" : "Sorry"
    return "\(reaction), you guessed \(number) the answer was \(actualNumber)."
}
```

Of course, these are just simple requests with no persistence and no coordination required on the server side. You will
build more in the sections to come.
