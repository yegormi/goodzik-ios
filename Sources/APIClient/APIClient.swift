import Dependencies
import DependenciesMacros
import SharedModels
import SwiftUI
import XCTestDynamicOverlay

@DependencyClient
public struct APIClient: Sendable {
    public var signup: @Sendable (SignupRequest) async throws -> AuthResponse
    public var login: @Sendable (LoginRequest) async throws -> AuthResponse

    public var getCurrentUser: @Sendable () async throws -> User
}

public extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
