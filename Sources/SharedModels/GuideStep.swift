import Foundation

public struct GuideStep: Equatable, Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let description: String
    public let imageURL: URL?

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        imageURL: URL?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}

// Mock data
public extension GuideStep {
    static let mock1 = GuideStep(
        title: "Кіберхуді",
        description: """
        Кіберхуді - одяг який дуже допомагає одужувати нашим хлопцям. Бо, якщо у пораненого нема одягу, в якому можна вийти на свіже повітря, то і одужання буде йти довше та важче.

        Весна - сезон худі.
        В "Швейній роті" - кіберхуді.
        """,
        imageURL: URL(
            string: "https://www.energy-community.org/.imaging/mte/bat/860/dam/IMAGES/UKRAINE/shutterstock_2130989432.jpg/jcr:content/hand.jpg"
        )
    )

    static let mock2 = GuideStep(
        title: "Кіберхуді",
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
        )
    )

    static let mock3 = GuideStep(
        title: "Кіберхуді",
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
        )
    )

    static let mocks: [GuideStep] = [
        .mock1, .mock2, .mock3,
    ]
}
