# 3.6 Add the GET HTTP verb with summary, description, and operationId

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Step 6

## Instructions

Update your `openapi.yaml` file as shown below.

```yaml
---
openapi: 3.1.1
info:
  title: PollsApp
  version: 0.1.0
servers:
  - url: /api
paths:
  /polls:
    get:
      summary: List polls
      description: Returns all the polls from the database
      operationId: listPolls
components:
  schemas:
    Poll:
      description: A poll
      properties:
        id:
          type: integer
          description: The primary key of the poll
        question:
          type: string
          description: The question asked
          example: "What is your favorite flavor of ice cream?"
      required:
        - id
        - question
```

You use the `GET` method in `/polls` to list polls and document this endpoint by including a `summary`, `description`,
and `operationId`.

This step highlights the GET method with proper documentation:

- The `summary` provides a brief description of what the endpoint does.
- The `description` gives more detail about the endpoint's behavior.
- The `operationId` provides a unique identifier that tools such as Swift OpenAPI use to generate function names.
