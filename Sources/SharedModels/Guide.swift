import Foundation

public struct Guide: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let date: Date
    public let imageURL: URL?
    public let videoURL: URL?
    public let categories: [Category]

    public init(
        id: String,
        title: String,
        description: String,
        date: Date,
        imageURL: URL? = nil,
        videoURL: URL? = nil,
        categories: [Category] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.categories = categories
    }
}

public extension Guide {
    static var underwear: Self {
        Guide(
            id: UUID().uuidString,
            title: "How to Sew Adaptive Underwear",
            description: "Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.Step-by-step guide for creating adaptive underwear for wounded warriors. Includes patterns and tips for different medical device accommodations.",
            date: Date().addingTimeInterval(-7 * 24 * 3600),
            imageURL: URL(
                string: "https://www.energy-community.org/.imaging/mte/bat/860/dam/IMAGES/UKRAINE/shutterstock_2130989432.jpg/jcr:content/hand.jpg"
            ),
            videoURL: URL(string: "https://www.youtube.com/watch?v=_p5p479n_X8"),
            categories: [.underwear]
        )
    }

    static var socks: Self {
        Guide(
            id: UUID().uuidString,
            title: "Making Medical Device-Friendly Socks",
            description: "Tutorial for sewing specialized socks that accommodate external fixation devices and other medical equipment. Perfect for rehabilitation needs.",
            date: Date().addingTimeInterval(-14 * 24 * 3600),
            imageURL: URL(
                string: "https://www.energy-community.org/.imaging/mte/bat/860/dam/IMAGES/UKRAINE/shutterstock_2130989432.jpg/jcr:content/hand.jpg"
            ),
            videoURL: URL(string: "https://www.youtube.com/watch?v=_p5p479n_X8"),
            categories: [.socks]
        )
    }
}
