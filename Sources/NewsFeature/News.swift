import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct NewsFeature: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?
        var newsItems: [News]?

        public init() {}
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {}

        public enum Internal {
            case fetchNewsResponse(Result<[News], Error>)
        }

        public enum View: Equatable, BindableAction {
            case binding(BindingAction<NewsFeature.State>)
            case onAppear
            case newsItemTapped(News)
        }
    }

    @Reducer(state: .equatable)
    public enum Destination {
        case newsDetail(NewsDetail)
    }

    @Dependency(\.apiClient) var api

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .destination:
                return .none

            case let .internal(.fetchNewsResponse(result)):
                switch result {
                case let .success(news):
                    state.newsItems = news
                case .failure:
                    break
                }

                return .none

            case .view(.binding):
                return .none

            case .view(.onAppear):
                return self.fetchNews(&state)

            case let .view(.newsItemTapped(item)):
                state.destination = .newsDetail(NewsDetail.State(item: item))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func fetchNews(_: inout State) -> Effect<Action> {
        .run { send in
            await send(.internal(.fetchNewsResponse(Result {
                try await self.api.getNews()
            })))
        }
    }
}
