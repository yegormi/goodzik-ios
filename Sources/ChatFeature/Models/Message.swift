import Foundation

public struct Message: Equatable, Identifiable {
    public let id: UUID
    let text: String
    let date: Date
    let isFromCurrentUser: Bool

    public init(
        id: UUID = UUID(),
        text: String,
        date: Date = Date(),
        isFromCurrentUser: Bool
    ) {
        self.id = id
        self.text = text
        self.date = date
        self.isFromCurrentUser = isFromCurrentUser
    }
}
