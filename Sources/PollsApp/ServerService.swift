import Vapor

 func routes(_ application: Application) {
            defaultRoute(application)  // adding the route called when there is no path
        }
        func defaultRoute(_ application: Application) {
            application.get { request in
                return "Hello, Server Routes!"
            }
        }
func configureServer(_ application: Application) async throws -> Application {
    routes(application)
    return application
}