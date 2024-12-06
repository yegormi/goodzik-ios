//
//  Step.swift
//  goodzik-ios
//
//  Created by Yehor Myropoltsev on 06.12.2024.
//
import Foundation

public extension GuideDetails {
    struct Step: Identifiable, Equatable, Sendable {
        public let id: String
        public let name: String
        public let description: String
        public let imageURL: URL?
        public let order: Int

        public init(
            id: String,
            name: String,
            description: String,
            imageURL: URL?,
            order: Int
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.imageURL = imageURL
            self.order = order
        }
    }
}

public extension GuideDetails {
    static var mock: GuideDetails {
        GuideDetails(
            id: "1",
            title: "mock",
            description: "mock desc",
            date: Date(),
            imageURLs: nil,
            videoURL: nil,
            steps: [.mock1, .mock2, .mock3]
        )
    }
}

public extension GuideDetails.Step {
    static let mock1 = GuideDetails.Step(
        id: UUID().uuidString,
        name: "Кіберхуді",
        description: """
        Кіберхуді - одяг який дуже допомагає одужувати нашим хлопцям. Бо, якщо у пораненого нема одягу, в якому можна вийти на свіже повітря, то і одужання буде йти довше та важче.

        Весна - сезон худі.
        В "Швейній роті" - кіберхуді.
        """,
        imageURL: URL(
            string: "https://www.energy-community.org/.imaging/mte/bat/860/dam/IMAGES/UKRAINE/shutterstock_2130989432.jpg/jcr:content/hand.jpg"
        ),
        order: 1
    )

    static let mock2 = GuideDetails.Step(
        id: UUID().uuidString,
        name: "Кіберхуді",
        description: """
        Кіберхуді - одяг який дуже допомагає одужувати нашим хлопцям. Бо, якщо у пораненого нема одягу, в якому можна вийти на свіже повітря, то і одужання буде йти довше та важче.

        Весна - сезон худі.
        В "Швейній роті" - кіберхуді.
        Кіберхуді - одяг який дуже допомагає одужувати нашим хлопцям. Бо, якщо у пораненого нема одягу, в якому можна вийти на свіже повітря, то і одужання буде йти довше та важче.

        Весна - сезон худі.
        В "Швейній роті" - кіберхуді.
        """,
        imageURL: URL(
            string: "https://www.energy-community.org/.imaging/mte/bat/860/dam/IMAGES/UKRAINE/shutterstock_2130989432.jpg/jcr:content/hand.jpg"
        ),
        order: 2
    )

    static let mock3 = GuideDetails.Step(
        id: UUID().uuidString,
        name: "Кіберхуді",
        description: """
        Кіберхуді - одяг який дуже допомагає одужувати нашим хлопцям. Бо, якщо у пораненого нема одягу, в якому можна вийти на свіже повітря, то і одужання буде йти довше та важче.

        Весна - сезон худі.
        В "Швейній роті" - кіберхуді.
        Кіберхуді - одяг який дуже допомагає одужувати нашим хлопцям. Бо, якщо у пораненого нема одягу, в якому можна вийти на свіже повітря, то і одужання буде йти довше та важче.

        Весна - сезон худі.
        В "Швейній роті" - кіберхуді.
        Кіберхуді - одяг який дуже допомагає одужувати нашим хлопцям. Бо, якщо у пораненого нема одягу, в якому можна вийти на свіже повітря, то і одужання буде йти довше та важче.

        Весна - сезон худі.
        В "Швейній роті" - кіберхуді.
        """,
        imageURL: URL(
            string: "https://www.energy-community.org/.imaging/mte/bat/860/dam/IMAGES/UKRAINE/shutterstock_2130989432.jpg/jcr:content/hand.jpg"
        ),
        order: 3
    )

    static let mocks: [GuideDetails.Step] = [
        .mock1, .mock2, .mock3,
    ]
}
