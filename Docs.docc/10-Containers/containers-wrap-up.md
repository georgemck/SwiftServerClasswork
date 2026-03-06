# Wrap up

@Metadata {
    @PageKind(article)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

## Verify solutions

You reached an important milestone. You successfully packaged your Swift application into a container and tested it
locally, proving that your application runs in a controlled, reproducible environment. This containerization step
transforms your application from something that works only on your development machine into something that runs
consistently anywhere.

Your application now carries its entire runtime environment. The production server no longer needs the right Swift
version installed, or correctly configured dependencies. The container encapsulates everything.

### Verification process

Before moving forward, confirm your success. Build your container image and run it locally to verify your application
functions correctly in a containerized environment. This local testing proves that your application is portable and
ready for the next step in your deployment journey.

Start the container and make requests to the API. When your polls endpoints respond correctly, you know the
containerization worked. This is the same container you deploy to production - what runs locally runs identically in the
cloud.

## Additional resources

The world of containerization extends far beyond your initial implementation. To deepen your understanding and refine
your containerization strategy, explore these directions:

- Review the [Vessel documentation](https://vessel.apple.com/documentation/vessel-desktop-doc/apple-containerization)
  for advanced containerization patterns that optimize your builds and improve your deployment strategies.
- Explore Docker best practices for optimizing container image size and build performance. Smaller images deliver faster
  deployments and lower storage costs.
- Learn about multi-stage builds to reduce final image size and improve security. This technique uses one container for
  building your application and another, more minimal container for running it.

These resources open possibilities for refining your containerization approach, making your deployments faster, more
secure, and more efficient.
