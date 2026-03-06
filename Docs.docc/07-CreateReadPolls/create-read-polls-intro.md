# Introduction

@Metadata {
    @PageKind(article)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Build "create a poll" functionality with a `POST` endpoint and two `GET` endpoints for "listing all polls" and
"retrieving a poll by its ID". Use test-driven development with Swift Testing.

## Objectives

Many applications allow users to create and list resources. By the end of this lab, you will understand how to:

- Create a `POST` endpoint in OpenAPI for creating a poll.
- Create a `POST` endpoint with Swift OpenAPI.
- Create two `GET` endpoints in OpenAPI, to retrieve all polls or specific
  polls.
- Create the two `GET` endpoints with Swift OpenAPI.

## What are RESTful resources?

RESTful resources use standard HTTP verbs to define operations on entities accessed through URL paths. This pattern is
common in many web frameworks such as Java Spring, Ruby on Rails, Django, Phoenix, and many more. For a given resource
(such as the polls), consider the following endpoints and verbs:

- `GET /polls` retrieves all of the polls or a subset based on query parameters (for example, polls created after
  September).
- `POST /polls` creates a new poll. Typically, an ID is assigned by the web application after validating and creating
  the record.
- `GET /poll/{id}` retrieves a poll by its ID.
- `PATCH /poll/{id}` updates a poll by its ID and a given request body. In some frameworks, `PATCH` is replaced by
  `PUT`.
- `DELETE /poll/{id}` deletes a poll by its ID.
