import APIClient
import Foundation
import SharedModels

struct InvalidURLError: Error {}

extension URL? {
    init(validating stringURL: String) {
        guard let url = URL(string: stringURL) else {
            self = nil
            return
        }
        self = url
    }
}

extension Components.Schemas.GuideDto {
    func toDomain() -> Guide {
        Guide(
            id: self.id,
            title: self.title,
            description: self.description,
            date: self.date,
            videoURL: .init(validating: self.videoUrl),
            exampleImageURLs: self.exampleImages.compactMap { .init(validating: $0) },
            author: self.author.toDomain()
        )
    }
}

extension Components.Schemas.GuideCategoryDto {
    func toDomain() -> GuideCategory {
        GuideCategory(
            id: self.id,
            name: self.name
        )
    }
}

extension Components.Schemas.GuideStepDto {
    func toDomain() -> GuideDetails.Step {
        GuideDetails.Step(
            id: self.id,
            name: self.name,
            description: self.description,
            imageURL: .init(validating: self.image),
            order: Int(self.order)
        )
    }
}

extension Components.Schemas.GuideDetailsDto {
    func toDomain() -> GuideDetails {
        GuideDetails(
            id: self.id,
            title: self.title,
            description: self.description,
            date: self.date,
            imageURLs: self.exampleImages.compactMap { .init(validating: $0) },
            videoURL: .init(validating: self.videoUrl),
            steps: self.steps.map { $0.toDomain() }
        )
    }
}

extension Components.Schemas.NewsDto {
    func toDomain() -> NewsItem {
        NewsItem(
            id: self.id,
            title: self.title,
            date: self.date,
            description: self.description,
            categories: [],
            imageURls: self.image.compactMap { .init(validating: $0) },
            author: self.author
        )
    }
}
