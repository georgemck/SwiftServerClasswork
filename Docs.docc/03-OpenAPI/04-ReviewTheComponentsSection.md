# 3.4 Review the components section

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Step 4

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

The `components` section defines reusable schemas. Here, it specifies the structure of a `Poll` object. This defines a
`Poll` schema with a required `question` field of type `string`, and an `id` field of type `integer`.
