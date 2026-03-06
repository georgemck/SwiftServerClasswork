# 10.3 Running the Grafana container

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 3

Run a Grafana observability container to monitor your Swift server application's performance, trace requests, and
analyze logs. This integrated observability stack includes Grafana for visualization, Loki for logs, Tempo for traces,
and Prometheus for metrics. Together, these components form the LGTM observability solution (Loki, Grafana, Tempo, and
Mimir or Prometheus for metrics storage).

## Starting the Grafana observability container

Open a separate Terminal.app tab and launch the Grafana OpenTelemetry LGTM container using the `container` command
provided by Vessel (installed in <doc:01-InstallingContainers>):

```bash
container run -p 3000:3000 -p 4317:4317 -p 4318:4318 grafana/otel-lgtm:latest
```

This command exposes three essential ports:

- Port 3000: Grafana web interface for viewing dashboards and exploring telemetry data.
- Port 4317: OpenTelemetry Protocol (OTLP) gRPC endpoint for receiving telemetry from your application.
- Port 4318: OpenTelemetry Protocol (OTLP) HTTP endpoint as an alternative ingestion method.

## Verifying the observability stack

Open your web browser and navigate to `http://127.0.0.1:3000` to access the Grafana dashboard. The interface loads,
confirming your observability container operates correctly.

Keep this container running - later sections configure your Swift server to send telemetry data to this observability
stack, enabling real-time monitoring and performance analysis of your application.
