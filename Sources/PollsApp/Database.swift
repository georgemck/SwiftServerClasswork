import Fluent
import FluentSQLiteDriver
import Foundation
import Vapor

enum DatabaseError: Error, LocalizedError {
    case migrationFailed(String)
    case configurationFailed(String)

    var errorDescription: String? {
        switch self {
        case .migrationFailed(let message):
            return "Database migration failed: \(message)"
        case .configurationFailed(let message):
            return "Database configuration failed: \(message)"
        }
    }
}

func configureDatabase(_ application: Application) async throws {
    do {
        // Configure SQLite database
        application.databases.use(.sqlite(.memory), as: .sqlite)

        // Add migrations (you will create these in a later step)
        application.migrations.add([
            // Migrations will be added here
        ])

        // Run migrations automatically
        try await application.autoMigrate()
    } catch {
        let errorMessage = error.localizedDescription
        if errorMessage.contains("migration") || errorMessage.contains("Migration") {
            throw DatabaseError.migrationFailed(errorMessage)
        } else {
            throw DatabaseError.configurationFailed(errorMessage)
        }
    }
}