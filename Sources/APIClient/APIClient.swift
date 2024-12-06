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
    public var getNews: @Sendable () async throws -> [News]

    // Guides
    public var createGuide: @Sendable (CreateGuideRequest) async throws -> Guide
    public var getGuides: @Sendable () async throws -> [Guide]
    public var getGuide: @Sendable (String) async throws -> Guide
    public var updateGuide: @Sendable (String, UpdateGuideRequest) async throws -> Void
    public var deleteGuide: @Sendable (String) async throws -> Void

    // Guide Categories
    public var createGuideCategory: @Sendable (CreateGuideCategoryRequest) async throws -> GuideCategory
    public var getGuideCategories: @Sendable () async throws -> [GuideCategory]
    public var getGuideCategory: @Sendable (String) async throws -> GuideCategory
    public var updateGuideCategory: @Sendable (String, UpdateGuideCategoryRequest) async throws -> Void
    public var deleteGuideCategory: @Sendable (String) async throws -> Void

    // Guide Steps
    public var createGuideStep: @Sendable (CreateGuideStepRequest) async throws -> GuideStep
    public var getGuideSteps: @Sendable () async throws -> [GuideStep]
    public var getGuideStep: @Sendable (String) async throws -> GuideStep
    public var updateGuideStep: @Sendable (String, UpdateGuideStepRequest) async throws -> Void
    public var deleteGuideStep: @Sendable (String) async throws -> Void
}

public extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
