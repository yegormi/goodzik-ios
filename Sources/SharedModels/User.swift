import Foundation

public struct User: Codable, Sendable, Equatable {
    public let id: String
    public let username: String?
    public let email: String
    public let role: String?

    public init(
        id: String,
        username: String? = nil,
        email: String,
        role: String? = nil
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.role = role
    }
}

public extension User {
    static var mock: Self {
        User(
            id: "1",
            username: "Mock user",
            email: "mock@gmail.com",
            role: "user"
        )
    }
}
