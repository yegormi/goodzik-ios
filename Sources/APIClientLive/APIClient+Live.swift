import APIClient
import Dependencies
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import SharedModels
import SwiftHelpers
import XCTestDynamicOverlay

private func throwingUnderlyingError<T>(_ closure: () async throws -> T) async throws -> T {
    do {
        return try await closure()
    } catch let error as ClientError {
        throw error.underlyingError
    }
}

extension APIClient: DependencyKey {
    public static var liveValue: Self {
        let client = Client(
            serverURL: try! Servers.Server1.url(), // swiftlint:disable:this force_try
            configuration: Configuration(
                dateTranscoder: .iso8601WithFractions
            ),
            transport: URLSessionTransport(),
            middlewares: [
                ErrorMiddleware(),
                AuthenticationMiddleware(),
                LoggingMiddleware(bodyLoggingConfiguration: .upTo(maxBytes: 1024)),
            ]
        )
        
        return Self(
            signup: { request in
                try await throwingUnderlyingError {
                    try await client
                        .signup(body: .json(request.toAPI()))
                        .created
                        .body
                        .json
                        .toDomain()
                }
            },
            login: { request in
                try await throwingUnderlyingError {
                    try await client
                        .login(body: .json(request.toAPI()))
                        .created
                        .body
                        .json
                        .toDomain()
                }
            },
            getCurrentUser: {
                try await throwingUnderlyingError {
                    try await client
                        .getMe()
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            }
        )
    }
}
