import APIClient
import Foundation
import SharedModels

struct InvalidURLError: Error {}

extension URL {
    init(validating stringURL: String) throws {
        guard let components = URLComponents(string: stringURL) else {
            throw InvalidURLError()
        }
        guard let url = components.url else { throw InvalidURLError() }
        self = url
    }
}

extension Components.Schemas.GuideDto {
    func toDomain() throws -> Guide {
        try Guide(
            id: self.id,
            title: self.title,
            description: self.description,
            date: self.date,
            imageURL: .init(validating: self.imageUrl),
            videoURL: .init(validating: self.videoUrl)
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
    func toDomain() throws -> GuideStep {
        try GuideStep(
            id: self.id,
            title: self.name,
            description: self.description,
            imageURL: .init(validating: self.image),
            order: Int(self.order)
        )
    }
}

extension Components.Schemas.NewsDto {
    func toDomain() throws -> News {
        try News(
            id: self.id,
            title: self.title,
            date: self.date,
            description: self.description,
            categories: [],
            imageURls: self.image.map { try .init(validating: $0) },
            author: self.author
        )
    }
}

extension CreateGuideRequest {
    func toAPI() -> Components.Schemas.CreateGuideDto {
        .init(
            title: self.title,
            description: self.description,
            imageUrl: self.imageUrl,
            videoUrl: self.videoUrl,
            categories: self.categories
        )
    }
}

extension UpdateGuideRequest {
    func toAPI() -> Components.Schemas.UpdateGuideDto {
        .init(
            title: self.title,
            description: self.description,
            imageUrl: self.imageUrl,
            videoUrl: self.videoUrl,
            categories: self.categories
        )
    }
}

extension CreateGuideCategoryRequest {
    func toAPI() -> Components.Schemas.CreateGuideCategoryDto {
        .init(name: self.name)
    }
}

extension UpdateGuideCategoryRequest {
    func toAPI() -> Components.Schemas.UpdateGuideCategoryDto {
        .init(name: self.name)
    }
}

extension CreateGuideStepRequest {
    func toAPI() -> Components.Schemas.CreateGuideStepDto {
        .init(
            name: self.name,
            description: self.description,
            image: self.image,
            order: Double(self.order)
        )
    }
}

extension UpdateGuideStepRequest {
    func toAPI() -> Components.Schemas.UpdateGuideStepDto {
        .init(
            name: self.name,
            description: self.description,
            image: self.image,
            order: Double(self.order)
        )
    }
}
