import Vapor

@main
enum EntryPoint {
    static func main() async throws {
        print("Hello, Vapor")
        let application = try await Application.make()

        func routes(_ application: Application) {
            defaultRoute(application)  // adding the route called when there is no path
        }
        routes(application)  // here's where you set up your routes
        try await application.execute()
    }

}

private func defaultRoute(_ application: Application) {
    application.get { _ in  // the copy of the default route
        "Hello, Routes!"
    }
}
// 01-IntroducingVapor/06-SimpleRoutes.md