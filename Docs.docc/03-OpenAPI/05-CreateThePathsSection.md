# 3.5 Create the paths section

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Step 5

## Instructions

Update your `openapi.yaml` file as shown below:

```yaml
---
openapi: 3.1.1
info:
  title: PollsApp
  version: 0.1.0
servers:
  - url: /api
paths:
  /polls: []
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

The `paths` section defines the API endpoints. The `/polls` path is initially empty, indicated by `[]`. Later, it will
contain the GET operation.
