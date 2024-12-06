import SharedModels

public extension APIClient {
    static let mock = Self(
        signup: { _ in .mock },
        login: { _ in .mock },
        getCurrentUser: { .mock },
        getNews: { [.mock] },
        createGuide: { _ in .socks },
        getGuides: { [.socks, .underwear] },
        getGuide: { _ in .socks },
        updateGuide: { _, _ in },
        deleteGuide: { _ in },
        createGuideCategory: { _ in .mock },
        getGuideCategories: { [.mock] },
        getGuideCategory: { _ in .mock },
        updateGuideCategory: { _, _ in },
        deleteGuideCategory: { _ in },
        createGuideStep: { _ in .mock1 },
        getGuideSteps: { [.mock1, .mock2, .mock3] },
        getGuideStep: { _ in .mock1 },
        updateGuideStep: { _, _ in },
        deleteGuideStep: { _ in }
    )
}
