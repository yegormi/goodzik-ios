import Dependencies
import DependenciesMacros
import SharedModels
import SwiftUI
import XCTestDynamicOverlay

@DependencyClient
public struct APIClient: Sendable {
    // Auth
    public var signup: @Sendable (SignupRequest) async throws -> AuthResponse
    public var login: @Sendable (LoginRequest) async throws -> AuthResponse
    public var getCurrentUser: @Sendable () async throws -> User

    // News
    public var getNews: @Sendable () async throws -> [NewsItem]

    // Guides
    public var getGuides: @Sendable () async throws -> [Guide]
    public var getGuide: @Sendable (String) async throws -> GuideDetails

    // Guide Categories
    public var getGuideCategories: @Sendable () async throws -> [GuideCategory]
    public var getGuideCategory: @Sendable (String) async throws -> GuideCategory

    // Guide Steps
    public var getGuideSteps: @Sendable () async throws -> [GuideDetails.Step]
    public var getGuideStep: @Sendable (String) async throws -> GuideDetails.Step
}

public extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
