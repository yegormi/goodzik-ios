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
            // MARK: Auth

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
            },

            // MARK: News

            getNews: {
                try await throwingUnderlyingError {
                    try await client
                        .getNews()
                        .ok
                        .body
                        .json
                        .news
                        .map { try $0.toDomain() }
                }
            },

            // MARK: Guides

            createGuide: { request in
                try await throwingUnderlyingError {
                    try await client
                        .createGuide(body: .json(request.toAPI()))
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            },
            getGuides: {
                try await throwingUnderlyingError {
                    try await client
                        .getGuides()
                        .ok
                        .body
                        .json
                        .map { try $0.toDomain() }
                }
            },
            getGuide: { id in
                try await throwingUnderlyingError {
                    try await client
                        .getGuide(path: .init(id: id))
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            },
            updateGuide: { id, request in
                try await throwingUnderlyingError {
                    _ = try await client
                        .updateGuide(path: .init(id: id), body: .json(request.toAPI()))
                        .ok
                }
            },
            deleteGuide: { id in
                try await throwingUnderlyingError {
                    _ = try await client
                        .deleteGuide(path: .init(id: id))
                        .ok
                }
            },

            // MARK: Guide Categories

            createGuideCategory: { request in
                try await throwingUnderlyingError {
                    try await client
                        .createGuideCategory(body: .json(request.toAPI()))
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            },
            getGuideCategories: {
                try await throwingUnderlyingError {
                    try await client
                        .getGuideCategories()
                        .ok
                        .body
                        .json
                        .map { $0.toDomain() }
                }
            },
            getGuideCategory: { id in
                try await throwingUnderlyingError {
                    try await client
                        .getGuideCategory(path: .init(id: id))
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            },
            updateGuideCategory: { id, request in
                try await throwingUnderlyingError {
                    _ = try await client
                        .updateGuideCategory(path: .init(id: id), body: .json(request.toAPI()))
                        .ok
                }
            },
            deleteGuideCategory: { id in
                try await throwingUnderlyingError {
                    _ = try await client
                        .deleteGuideCategory(path: .init(id: id))
                        .ok
                }
            },

            // MARK: Guide Steps

            createGuideStep: { request in
                try await throwingUnderlyingError {
                    try await client
                        .createGuideStep(body: .json(request.toAPI()))
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            },
            getGuideSteps: {
                try await throwingUnderlyingError {
                    try await client
                        .getGuideSteps()
                        .ok
                        .body
                        .json
                        .map { try $0.toDomain() }
                }
            },
            getGuideStep: { id in
                try await throwingUnderlyingError {
                    try await client
                        .getGuideStep(path: .init(id: id))
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            },
            updateGuideStep: { id, request in
                try await throwingUnderlyingError {
                    _ = try await client
                        .updateGuideStep(path: .init(id: id), body: .json(request.toAPI()))
                        .ok
                }
            },
            deleteGuideStep: { id in
                try await throwingUnderlyingError {
                    _ = try await client
                        .deleteGuideStep(path: .init(id: id))
                        .ok
                }
            }
        )
    }
}
