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
    public let imageURls: [URL]?

    public init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        description: String,
        categories: [Category],
        imageURls: [URL]? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
        self.categories = categories
        self.imageURls = imageURls
    }
}

public extension NewsItem {
    static var mock: Self {
        .init(
            title: "Sew gathering in Kiev",
            date: Date(),
            description: "Learn how to sew linen with ease using our step-by-step guide. From selecting the right fabric to mastering essential...",
            categories: [.socks, .underwear],
            imageURls: [
                URL(string: "https://canto-wp-media.s3.amazonaws.com/app/uploads/2019/08/19194138/image-url-3.jpg")!,
                URL(string: "https://canto-wp-media.s3.amazonaws.com/app/uploads/2019/08/19194138/image-url-3.jpg")!,
                URL(string: "https://canto-wp-media.s3.amazonaws.com/app/uploads/2019/08/19194138/image-url-3.jpg")!,
            ]
        )
    }
}
