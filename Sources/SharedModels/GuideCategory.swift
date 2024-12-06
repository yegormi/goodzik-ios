import Foundation

public struct GuideCategory: Equatable, Sendable, Identifiable {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    public static let mock = Self(
        id: "mock-id",
        name: "Mock Category"
    )
}
