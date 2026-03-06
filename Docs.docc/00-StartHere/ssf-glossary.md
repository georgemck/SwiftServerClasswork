# SSF glossary

@Metadata {
    @PageKind(article)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Terms are organized by functional category to support progressive learning.

## A

**Actor** A Swift concurrency primitive that provides thread-safe access to mutable state by ensuring only one task
can access the actor's properties at a time. In server development, actors help manage shared resources like database
connections safely across concurrent requests.

**Agent** A background process that collects and forwards telemetry data (metrics, logs, traces) from applications to
monitoring systems. Agents run alongside your server application to gather performance and diagnostic information.

**Automatic Reference Counting (ARC)** Swift's memory management system that automatically deallocates objects when
they're no longer referenced.

## C

**Cache** A high-speed storage layer that keeps frequently accessed data in memory for faster retrieval. Server
applications use caching to reduce database load and improve response times for expensive operations.

**Containerization** The practice of packaging applications with their dependencies into lightweight, portable
containers that run consistently across different environments. Docker is the most common containerization platform.

**CRUD** Create, Read, Update, Delete - the four basic database operations that form the foundation of most API
endpoints. REST APIs typically map CRUD operations to HTTP methods (`POST`, `GET`, `PUT/PATCH`, `DELETE`).

**CURL** A [command line](https://curl.se) tool for making HTTP requests, essential for testing API endpoints during
development. Server developers use curl to verify their APIs work correctly before building client applications.

## D

**Docker** A platform for building, shipping, and running applications in containers. Swift server applications are
often deployed as containers to ensure consistent behavior across development, testing, and production environments.

## E

**Exporter** A service component that sends telemetry data (metrics, logs, traces) from a server to an external
monitoring system like Prometheus or Jaeger.

## F

**Fluent ORM** Vapor's official Object-Relational Mapper (ORM) that provides a Swift-native interface for database
operations. ORMs are programming tools that map database tables to objects. This allows developers to work with
databases using familiar object-oriented patterns instead of raw SQL. Fluent specifically enables defining models as
Swift structs/classes and performing type-safe database queries using expressive Swift syntax.

## G

**gRPC** A high-performance, cross-platform RPC framework that uses Protocol Buffers for serialization.

## H

**Homebrew** A popular [package manager](https://brew.sh/) for macOS that simplifies installing development tools and
dependencies. Server developers often use Homebrew to install databases, monitoring tools, and other development
utilities.

## I

**Instrument** To add monitoring code to your application that measures performance, tracks errors, or records business
metrics. Instrumentation is essential for understanding how your server behaves in production.

## J

**Jaeger UI** A web-based interface for visualizing [distributed traces](https://www.jaegertracing.io) collected by the
Jaeger tracing system. Developers use Jaeger UI to debug performance issues and understand request flows across
microservices.

## M

**Middleware** Code that sits between the web server and your application logic, processing requests and responses as
they flow through the system. Common middleware includes authentication, logging, error handling, and CORS
(Cross-Origin Resource Sharing) functionality.

## O

**OpenAPI** An industry-standard specification for describing REST APIs, defining endpoints, request/response schemas,
and authentication methods. Swift servers can generate code from OpenAPI specs and automatically validate requests
against the specification.

**OpenTelemetry (OTel)** An open-source [observability framework](https://github.com/swift-otel/swift-otel) that
provides APIs and tools for collecting metrics, logs, and traces from applications. OpenTelemetry offers vendor-neutral
instrumentation for server applications.

## P

**Package.swift** The manifest file that defines a Swift package's dependencies, targets, and build configuration.
Server projects use this to declare dependencies on frameworks like Vapor, Fluent, and observability libraries.

**Prometheus** An open-source [monitoring system](https://prometheus.io) that collects numeric metrics from
applications and stores them in a time-series database. Server applications expose metrics endpoints that Prometheus
regularly scrapes for monitoring data.

**Protocol Buffers (Protobufs)** A language-neutral, platform-neutral serialization format developed by Google for
structured data.

## R

**REST** Representational State Transfer - an architectural style for designing web APIs that uses standard HTTP
methods and status codes. REST APIs are stateless and use URL paths to represent resources. They typically exchange
data in JSON format, which has made them the most common API design pattern for web services.

## S

**Span** A single unit of work within a distributed trace, representing an operation like a database query or HTTP
request. Spans contain timing information and metadata that help developers understand application performance.

**Structured Concurrency** Swift's modern concurrency model using async/await and Tasks to write safe, efficient
asynchronous code. Server applications heavily rely on structured concurrency to handle multiple simultaneous requests
without blocking.

**Structured Logging** A [logging approach](https://github.com/apple/swift-log) that outputs logs in a consistent,
machine-readable format (usually JSON) rather than free-form text. Structured logs are easier to search, filter, and
analyze in log management systems.

**Swift OpenAPI Generator** A Swift Package that generates type-safe client and server code from OpenAPI
specifications. This ensures your API implementation matches your documentation and enables compile-time validation of
API contracts.

**Swift Optional** Swift's type-safe way of representing values that might be absent, using `?` syntax. Server code
frequently works with optionals when parsing request data, querying databases, or handling configuration that might not
be present.

**Swift Protocol** Blueprint defining methods and properties that conforming types must implement. Server applications
use [protocols](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/) extensively
for defining API contracts and extending functionality through protocol extensions.

**Swift Service Lifecycle** The management of application startup, running, and shutdown phases, including proper
resource initialization and cleanup. The [Swift Service Lifecycle](https://github.com/swift-server/swift-service-
lifecycle) library helps server applications handle lifecycle events gracefully to avoid data loss and ensure reliable
operation.

## T

**Three Pillars of Observability** The foundational telemetry data types for monitoring applications: metrics
(numerical measurements), logs (event records), and traces (request flows). Together, these provide comprehensive
visibility into system behavior.

**Trace** A complete record of a request's journey through a distributed system, composed of multiple spans that show
each operation performed. Traces help developers understand performance bottlenecks and identify failures in complex
applications.

**Tree** A command-line utility (installed via `brew install tree`) that displays directory and file structures in a
hierarchical, visual format. Server developers use tree to quickly understand project organization and verify file
structures when documenting or debugging applications.

## V

**Vapor** The most popular Swift web framework for building HTTP servers, APIs, and web applications.
[Vapor](https://github.com/vapor/vapor) provides routing, middleware, templating, and database integration in an
expressive, Swift-native way.
