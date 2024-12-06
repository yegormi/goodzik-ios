import Foundation

public struct CreateGuideRequest: Equatable {
    public let title: String
    public let description: String
    public let imageUrl: String
    public let videoUrl: String
    public let categories: [String]

    public init(
        title: String,
        description: String,
        imageUrl: String,
        videoUrl: String,
        categories: [String]
    ) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
        self.categories = categories
    }
}

public struct UpdateGuideRequest: Equatable {
    public let title: String
    public let description: String
    public let imageUrl: String
    public let videoUrl: String
    public let categories: [String]

    public init(
        title: String,
        description: String,
        imageUrl: String,
        videoUrl: String,
        categories: [String]
    ) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
        self.categories = categories
    }
}

public struct CreateGuideCategoryRequest: Equatable {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

public struct UpdateGuideCategoryRequest: Equatable {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

public struct CreateGuideStepRequest: Equatable {
    public let name: String
    public let description: String
    public let image: String
    public let order: Int

    public init(
        name: String,
        description: String,
        image: String,
        order: Int
    ) {
        self.name = name
        self.description = description
        self.image = image
        self.order = order
    }
}

public struct UpdateGuideStepRequest: Equatable {
    public let name: String
    public let description: String
    public let image: String
    public let order: Int

    public init(
        name: String,
        description: String,
        image: String,
        order: Int
    ) {
        self.name = name
        self.description = description
        self.image = image
        self.order = order
    }
}
