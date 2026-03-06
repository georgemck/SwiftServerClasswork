# 4.2 Generator configuration

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 2

## Adding the OpenAPI Generator configuration file

Create a configuration file that instructs OpenAPI Generator on what code to generate and how to format it.

Add a new file named `openapi-generator-config.yaml` to the `Sources/PollsApp` directory with the following content:

```yaml
generate:
  - types
  - server
accessModifier: public
namingStrategy: idiomatic
```

This configuration instructs the generator to create both type definitions and server protocol implementations with public
access and idiomatic Swift naming conventions.
