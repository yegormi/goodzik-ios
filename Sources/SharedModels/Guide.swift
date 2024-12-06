import Foundation

public struct Guide: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let date: Date
    public let videoURL: URL?
    public let exampleImageURLs: [URL]?
    public let categories: [Category]
    public let author: User

    public init(
        id: String,
        title: String,
        description: String,
        date: Date,
        videoURL: URL? = nil,
        exampleImageURLs: [URL]? = nil,
        categories: [Category] = [],
        author: User
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.videoURL = videoURL
        self.exampleImageURLs = exampleImageURLs
        self.categories = categories
        self.author = author
    }
}

public extension Guide {
    static var underwear: Self {
        Guide(
            id: "1",
            title: "How to Sew Adaptive Underwear",
            description: "Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.",
            date: Date().addingTimeInterval(-7 * 24 * 3600),
            videoURL: URL(string: "https://www.youtube.com/watch?v=_p5p479n_X8"),
            categories: [.underwear],
            author: .mock
        )
    }

    static var socks: Self {
        Guide(
            id: "2",
            title: "Making Medical Device-Friendly Socks",
            description: "Tutorial for sewing specialized socks that accommodate external fixation devices and other medical equipment. Perfect for rehabilitation needs.",
            date: Date().addingTimeInterval(-14 * 24 * 3600),
            videoURL: URL(string: "https://www.youtube.com/watch?v=_p5p479n_X8"),
            categories: [.socks],
            author: .mock
        )
    }
}
