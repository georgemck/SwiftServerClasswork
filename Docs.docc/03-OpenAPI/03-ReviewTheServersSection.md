# 3.3 Review the servers section

@Metadata {
    @PageKind(sampleCode)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Step 3

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
```

The `servers` section defines the base URL where the API endpoints are hosted. The API endpoints are served under the
`/api` path.
