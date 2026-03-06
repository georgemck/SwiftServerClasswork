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

# Build the application, with optimizations, with static linking
RUN swift build -c release \
        --product PollsApp \
        --static-swift-stdlib

FROM docker.apple.com/base-images/ubi${UBI_VERSION}-micro/ubi-micro

WORKDIR /code
RUN mkdir -p /code/bin

COPY --from=builder /code/.build/release/PollsApp /code/bin

ENV ENV=production

CMD ["/code/bin/PollsApp", "serve"]
EXPOSE 8080
