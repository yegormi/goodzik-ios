import Foundation

public struct Guide: Identifiable, Equatable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let date: Date
    public let categories: [Category]

    public var imageURL: URL {
        URL(
            string: "https://static.vecteezy.com/system/resources/thumbnails/012/658/321/small_2x/flag-of-ukraine-int-the-square-shape-country-in-europe-format-png.png"
        )!
    }
}

public extension Guide {
    static var underwear: Self {
        Guide(
            title: "How to Sew Adaptive Underwear",
            description: "Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.",
            date: Date().addingTimeInterval(-7 * 24 * 3600),
            categories: [.underwear]
        )
    }

    static var socks: Self {
        Guide(
            title: "Making Medical Device-Friendly Socks",
            description: "Tutorial for sewing specialized socks that accommodate external fixation devices and other medical equipment. Perfect for rehabilitation needs.",
            date: Date().addingTimeInterval(-14 * 24 * 3600),
            categories: [.socks]
        )
    }
}
