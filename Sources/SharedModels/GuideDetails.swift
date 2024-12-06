import Foundation

public struct GuideDetails: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let date: Date
    public let imageURLs: [URL]?
    public let videoURL: URL?
    public let steps: [Step]

    public init(
        id: String,
        title: String,
        description: String,
        date: Date,
        imageURLs: [URL]? = nil,
        videoURL: URL? = nil,
        steps: [Step]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.imageURLs = imageURLs
        self.videoURL = videoURL
        self.steps = steps
    }
}
