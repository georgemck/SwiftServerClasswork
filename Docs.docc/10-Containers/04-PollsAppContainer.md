# 10.4 Creating the PollsApp Container

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 4

With Grafana and Postgres running from how you downloaded containers, now create a container image for the
`PollsApp`.

## Building the Container Image

Copy this file as the `Dockerfile` in your project:

```bash
ARG SWIFT_VERSION=6.2
ARG UBI_VERSION=9

FROM docker.apple.com/base-images/ubi${UBI_VERSION}/swift${SWIFT_VERSION}-builder AS builder

WORKDIR /code

# First just resolve dependencies.
# This creates a cached layer that can be reused
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN swift package resolve \
        $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

# Copy the Sources dir into container
COPY ./Sources ./Sources
COPY ./Tests ./Tests

# Build the application, with optimizations, with static linking
RUN swift build -c release \
        --product PollsApp \
        --static-swift-stdlib

FROM docker.apple.com/base-images/ubi${UBI_VERSION}-minimal/ubi-minimal

RUN mkdir -p /code/bin

WORKDIR /code

COPY --from=builder /code/.build/release/PollsApp /code/bin
COPY --from=builder /code/Sources/PollsApp/Public /code/Sources/PollsApp/Public

ENV ENVIRONMENT=production

CMD ["/code/bin/PollsApp", "serve"]
EXPOSE 8080
```

This `Dockerfile` uses SDP base images to build your `PollsApp` executable using the builder image, then uses a
minimal linux image for the final binary.

Build the image with:

```bash
container build -t polls .
```

You should now have a container named `polls` on your machine.
