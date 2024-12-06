//
//  News.swift
//  goodzik-ios
//
import Foundation

public struct News: Equatable, Identifiable {
    public let id: String
    public let title: String
    public let date: Date
    public let description: String
    public let categories: [Category]
    public let imageURls: [URL]?
    public let author: String

    public init(
        id: String,
        title: String,
        date: Date,
        description: String,
        categories: [Category],
        imageURls: [URL]? = nil,
        author: String
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
        self.categories = categories
        self.imageURls = imageURls
        self.author = author
    }
}

public extension News {
    static var mock: Self {
        .init(
            id: UUID().uuidString,
            title: "Sew gathering in Kiev",
            date: Date(),
            description: "Learn how to sew linen with ease using our step-by-step guide. From selecting the right fabric to mastering essential...",
            categories: [.socks, .underwear],
            imageURls: [
                URL(string: "https://canto-wp-media.s3.amazonaws.com/app/uploads/2019/08/19194138/image-url-3.jpg")!,
                URL(string: "https://canto-wp-media.s3.amazonaws.com/app/uploads/2019/08/19194138/image-url-3.jpg")!,
                URL(string: "https://canto-wp-media.s3.amazonaws.com/app/uploads/2019/08/19194138/image-url-3.jpg")!,
            ],
            author: "Mariia Kudriavtseva"
        )
    }
}
