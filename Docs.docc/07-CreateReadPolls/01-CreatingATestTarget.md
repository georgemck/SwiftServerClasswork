# 7.1 Creating a test target

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 1

## Adding the test target to Package.swift

The following steps demonstrate test-driven development principles.

To add a test target to your `Package.swift` file, include:

```swift
targets: [
    .executableTarget(
        ... // executableTarget data here
    ),
    .testTarget( // add .testTarget at the same level as .executableTarget above
        name: "PollsAppTests",
        dependencies: [
            "PollsApp",
            .product(name: "VaporTesting", package: "vapor"),
        ]
    )
]
```

This test target depends on your main `PollsApp` module and includes `VaporTesting` for HTTP request simulation and
application testing utilities.

Create a new folder named `Tests` next to the `Sources` directory. Then create another folder within the `Tests` folder
and name it `PollsAppTests`.

## Understanding test-driven development

The remaining steps follow TDD principles:

1. Write a failing test that describes desired behavior.
2. Write minimal code to make the test pass.
3. Improve the implementation while keeping tests green.

This cycle of Red-Green-Refactor drives both design and implementation.

## Benefits of testing API endpoints

- Testing API endpoints provides confidence that endpoints work correctly under various conditions.
- Tests serve as executable specifications so that future developers understand intended behavior.
- They catch breaking changes early and provide feedback on API design issues before production deployment.

## Test categories

The tests cover several categories:

- Happy path scenarios where successful operations work with valid data.
- Error handling for invalid input, missing resources, and constraint violations.
- Edge cases such as empty data and boundary conditions.
- Integration tests that exercise end-to-end workflows combining multiple operations.

Run `swift test` to verify the test target builds correctly. You will see the error message:

```bash
...
error: no tests found; create a target in the 'Tests' directory
```

The next step creates a test helper to simplify application setup for each test.
