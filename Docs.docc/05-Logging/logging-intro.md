# Introduction

@Metadata {
    @PageKind(article)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Structured logging enables you to add information about your application in a way that helps engineers debug in
production.

## What is Swift Log?

Swift Log provides a unified logging API for server-side Swift applications, offering a standardized way to capture and
record information about your application's behavior and performance. As a foundational component of the Swift Server
ecosystem, it integrates seamlessly with frameworks like Vapor while maintaining the type safety and expressiveness that
Swift developers value.

[Swift Log](https://github.com/apple/swift-log) is a logging API developed to create consistent tooling for server-side
Swift. It provides a structured, extensible logging system that helps you track events, diagnose issues, and monitor
application health.

Swift Log offers:

- A standardized `Logger` type for emitting log messages.
- Multiple log levels to categorize messages by severity.
- Metadata support for attaching contextual information.
- A pluggable backend system allowing you to direct logs to various destinations.

## Using Swift Log in server-side development

For developers transitioning to server-side Swift, Swift Log addresses the unique challenges of server application
logging:

**Environment flexibility** Unlike client apps that log primarily to the console, server applications need to log to
files, monitoring systems, or cloud services.

**Production monitoring** Server logs must be structured for analysis across distributed systems.

**Performance considerations** Logging must be efficient to handle high-volume traffic without degrading application
performance.

**Security and privacy** Logs must carefully handle sensitive information to comply with privacy regulations.

### Getting started with Swift Log

To use Swift Log in your project:

1. Add the dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/apple/swift-log.git", from: "1.0.0")
```

2. Import the `Logging` module in your Swift files:

```swift
import Logging
```

3. Create a `Logger` instance:

```swift
let logger = Logger(label: "com.example.myapp")
```

4. Log messages at appropriate levels:

```swift
logger.trace("Entering function")
logger.debug("Configuration loaded: \(config)")
logger.info("Server started successfully")
logger.notice("Important system event occurred")
logger.warning("Resource usage approaching threshold")
logger.error("Failed to connect to database")
logger.critical("System is in an unstable state")
```

## Objectives

- **Apply** understanding of Swift log to create logs.
- **Explain** the different logging formats.
