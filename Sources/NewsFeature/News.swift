import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct News: Reducer {
    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?
        var newsItems: [NewsItem]

        public init() {
            self.newsItems = Array(repeating: NewsItem.mock, count: 10).map {
                NewsItem(
                    id: UUID(),
                    title: $0.title,
                    date: $0.date,
                    description: $0.description,
                    categories: $0.categories,
                    imageURL: $0.imageURL
                )
            }
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate: Equatable {}
        public enum Internal: Equatable {}
        public enum View: Equatable, BindableAction {
            case binding(BindingAction<News.State>)
            case onAppear
            case newsItemTapped(NewsItem)
        }
    }

    @Reducer(state: .equatable)
    public enum Destination {
        case newsDetail(NewsDetail)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .destination:
                return .none

            case .internal:
                return .none

            case .view(.binding):
                return .none

            case .view(.onAppear):
                return .none

            case let .view(.newsItemTapped(item)):
                state.destination = .newsDetail(NewsDetail.State(item: item))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
