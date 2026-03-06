# 3.7 PageOfPolls

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Step 7

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
    PageOfPolls:
      description: A single page of polls.
      properties:
        polls:
          type: array
          items:
            $ref: "#/components/schemas/Poll"
      required:
        - polls
```

For a `GET` request to the `/polls` endpoint, the `PollsApp` should return an array of polls. In OpenAPI, a common
practice is to implement a `PageOfPolls` schema which returns an array of Polls.
