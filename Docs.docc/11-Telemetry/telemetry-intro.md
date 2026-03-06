# Introduction

@Metadata {
    @PageKind(article)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Use Open Telemetry and the Swift OTel library to capture logs, metrics, and traces.

## Objectives

Open Telemetry is a common format for logs, metrics, and traces that work with a wide-range of providers. By the end of
this lab, you understand how to:

- Implement Swift OTel.
- Use Grafana for logs, metrics, and traces.

## What is OpenTelemetry?

[OpenTelemetry][1] is a common format for common problems. Nearly all applications, irrespective of the language, have
production needs to monitor their behavior. Applications need to see logs as they run. They need to capture metrics
like "How many times was this endpoint hit?" They need to see traces that detail how long a function took to execute
and how functions called other functions.

[1]: https://opentelemetry.io
