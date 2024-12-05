//
//  NewsItem.swift
//  goodzik-ios
//
import Foundation

public struct NewsItem: Equatable, Identifiable {
    public let id: UUID
    public let title: String
    public let date: Date
    public let description: String
    public let categories: [Category]
    public let imageURL: URL?

    public init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        description: String,
        categories: [Category],
        imageURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
        self.categories = categories
        self.imageURL = imageURL
    }
}

public extension NewsItem {
    static var mock: Self {
        .init(
            title: "Sew gathering in Kiev",
            date: Date(),
            description: "Learn how to sew linen with ease using our step-by-step guide. From selecting the right fabric to mastering essential...",
            categories: [.socks, .underwear]
        )
    }
}
