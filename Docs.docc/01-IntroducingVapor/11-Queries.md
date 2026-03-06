# 1.11 Queries

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

## Making queries

Although legal, it seems odd to pass your guess in as a path component.

```bash
curl localhost:8080/guess/2
```

It might feel more familiar to pass your guess in as a query like this:

```bash
curl "localhost:8080/guess?number=2"
```

> Note the quotes around the URL

To receive and parse this query, copy and paste the method call for `guess.get(":number")` and make two changes.

First, the route no longer includes the slot for `number`, so the call becomes `guess.get`.

```swift
guess.get(":number") // ...
```

And make two changes to the second version.

First, the route no longer includes the slot for number so the call is `guess.get`.

Second, read the query entry that matches "number". The syntax for this is similar to asking for a value for a given key
in a Dictionary.

```swift
request.query["number"]
```

As with a dictionary lookup, the result is an optional. Assign the value to `number` if it is both not `nil` and if it
is an `Int`. You are required to specify that `number` is an `Int` (i.e. on the left side of the equals sign).

```swift
private func guessRoutes(_ application: Application) {
  application.group("guess") { guess in
    guess.get(":number") { request in
      guard let number = request.parameters.get("number",
                                                 as: Int.self) else {
        throw GuessError.notAnInteger.abort
      }
      return try respond(to: number)
    }

    guess.get { request in   // number is not part of the path
      guard let number: Int = request.query["number"] else {  // get the value of number
        throw GuessError.notAnInteger.abort
      }
      return try respond(to: number)
    }
  }
}
```

The previous requests still work, and now you have added four more cases in response to the query.

## Test the query

Use curl to test this added endpoint.

Try to hit the guess endpoint without a query.

```bash
curl -i "localhost:8080/guess"
```

You get an error:

```txt
HTTP/1.1 400 Bad Request
content-type: application/json; charset=utf-8
content-length: 47
connection: keep-alive
date: Sat, 06 Sep 2025 23:45:21 GMT

{"error":true,"reason":"number must be an Int"}
```

Pass in something that is not an `Int` literal.

```bash
curl -i "localhost:8080/guess?number=seven"
```

You get the same error.

Pass in something that is out of range.

```bash
curl -i "localhost:8080/guess?number=347"
```

You get the out-of-range error.

```txt
HTTP/1.1 416 Request Range Not Satisfied
content-type: application/json; charset=utf-8
content-length: 53
connection: keep-alive
date: Sat, 06 Sep 2025 23:46:27 GMT

{"error":true,"reason":"347 is not between 1 and 10"}
```

Pass in something that is in range.

```bash
curl "localhost:8080/guess?number=7"
```

You get a response that indicates whether or not you guessed correctly.

```txt
Sorry, you guessed 7 the answer was 10
```

Finish this intro with an example that uses a POST that includes JSON to pass along your guess.
