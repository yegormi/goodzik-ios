import SharedModels

public extension APIClient {
    static let mock = Self(
        signup: { _ in .mock },
        login: { _ in .mock },
        getCurrentUser: { .mock },
        getNews: { [.mock] },
        getGuides: { [.socks, .underwear] },
        getGuide: { _ in .mock },
        getGuideCategories: { [.mock] },
        getGuideCategory: { _ in .mock },
        getGuideSteps: { [.mock1, .mock2, .mock3] },
        getGuideStep: { _ in .mock1 }
    )
}
