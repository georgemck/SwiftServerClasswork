# 3.8 Define the responses

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Step 8

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
      responses:
        "200":
          description: Returns the list of polls.
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/PageOfPolls"
components:
  schemas:
    Poll:
      description: A poll
      properties:
        question:
          type: string
          description: The question asked
          example: "What is your favorite flavor of ice cream?"
        id:
          type: integer
          description: The primary key of the poll
      required:
        - question
        - id
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

This step specifies that the `/polls` endpoint returns the `PageOfPolls`. A `200` status code indicates successful
retrieval of the polls list.
