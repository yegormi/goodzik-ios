import Foundation

public struct Category: Identifiable, Equatable {
    public let id: String
    public let name: String
}

public extension Category {
    static var underwear: Self {
        Category(id: "1", name: "Underwear")
    }

    static var socks: Self {
        Category(id: "2", name: "Socks")
    }
}
