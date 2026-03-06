# Wrap up

@Metadata {
    @PageKind(article)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Test your ServiceLifecycle integration to confirm proper service management and graceful shutdown capabilities.

## Key concepts

Your updated `Entrypoint.swift` file introduces several key `ServiceLifecycle` concepts.

### Error handling patterns

The call to `configureServer` executes within a `do`/`catch` block to capture and handle potential startup failures.
Swift applications should always handle errors explicitly rather than allowing them to propagate uncaught.

### ServiceGroup configuration

The `ServiceGroup` requires these essential parameters:

- `services`: An array containing objects that conform to the `Service` protocol. In this case, the array contains the
  `ServerService` that wraps the Vapor application.
- `gracefulShutdownSignals`: Defines which system signals trigger graceful shutdown. The `SIGINT` signal (typically
  Control+C) allows services to complete current operations before terminating.
- `cancellationSignals`: Specifies signals that force immediate cancellation. The `SIGTERM` signal provides a stronger
  shutdown mechanism when graceful shutdown takes too long.
- `logger`: The logging instance for `ServiceLifecycle` operations. This example uses the Vapor application's logger to
  maintain consistent logging throughout the application.

### Service execution model

Instead of calling `application.execute()` directly, the entrypoint invokes `try await serviceGroup.run()`. This change
integrates the Vapor application with `ServiceLifecycle`'s managed execution environment, providing consistent lifecycle
management across all services.

### Failure recovery

The `catch` block handles two categories of failures: service creation errors and runtime execution errors. When either
occurs, the application performs cleanup by calling `application.asyncShutdown()`, logs the error with context, and
exits with status code `1` to signal the failure to the operating system or process manager.

## Additional resources

To further expand your knowledge of service lifecycle management:

- Review the [Swift ServiceLifecycle documentation](https://github.com/swift-server/swift-service-lifecycle) for
  advanced patterns.
- Explore service dependency management and coordination strategies.
- Learn about monitoring and observability integration with lifecycle events.
