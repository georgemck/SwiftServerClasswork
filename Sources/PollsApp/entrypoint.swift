import Vapor

@main
enum EntryPoint {
    static func main() async throws {
        print("Hello, Configured Server")
        var application = try await Application.make()

        routes(application)  // here's where you set up your routes
        application = try await configureServer(application)
        try await application.execute()
    }

}

// 02-ServiceLifecycle/02-AbstractingAConfigureServiceMethod.md

