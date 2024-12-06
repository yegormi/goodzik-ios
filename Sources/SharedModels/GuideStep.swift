import Foundation

public struct GuideStep: Equatable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let description: String
    public let imageURL: URL?
    public let order: Int

    public init(
        id: String,
        title: String,
        description: String,
        imageURL: URL?,
        order: Int
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.order = order
    }
}

// Mock data
public extension GuideStep {
    static let mock1 = GuideStep(
        id: UUID().uuidString,
        title: "Кіберхуді",
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

    static let mock2 = GuideStep(
        id: UUID().uuidString,
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
        ),
        order: 2
    )

    static let mock3 = GuideStep(
        id: UUID().uuidString,
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
        ),
        order: 3
    )

    static let mocks: [GuideStep] = [
        .mock1, .mock2, .mock3,
    ]
}
