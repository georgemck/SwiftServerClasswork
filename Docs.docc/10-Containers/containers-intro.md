# Introduction

@Metadata {
    @PageKind(article)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

You built a Swift server application that handles polls, integrates with a database, and exposes a clean API. Your
application runs beautifully on your development machine. But the challenge remains: how do you ensure it runs just as
well in production? How do you guarantee that the deployment environment matches your development environment exactly?

Containers solve this challenge. In this section, you explore packaging your Swift application into a container - a
self-contained, portable unit that carries everything your application needs to run. Think of it as creating a sealed
environment that includes not just your compiled code, but also the complete runtime, dependencies, and configuration
needed for consistent execution.

Containerization solves one of software deployment's oldest problems: "it works on my machine." By packaging your
application with its complete environment, you ensure identical behavior across all stages - from local testing to
staging deployments to production servers around the world.

The journey through this section prepares your application for real-world deployment, transforming it from a local
development project into a production-ready service.

## Objectives

* **Create** containers for Postgres, Grafana, and your application.
