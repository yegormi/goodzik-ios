import Foundation
import SharedModels

public struct AuthResponse: Codable, Sendable {
    public let accessToken: String
    public let user: User

    public init(accessToken: String, user: User) {
        self.accessToken = accessToken
        self.user = user
    }
}

public extension AuthResponse {
    static var mock: Self {
        AuthResponse(accessToken: "8as7d68f9a7s69876g9s8ad6g", user: .mock)
    }
}
