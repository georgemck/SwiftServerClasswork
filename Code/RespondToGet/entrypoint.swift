import Vapor

@main
enum EntryPoint {
    static func main() async throws {
        print("Hello, Vapor")
        let application = try await Application.make()
        application.get( "hello", "server") { request in    // use get()
            "Hello, Server!"
        }
        try await application.execute()
    }
}
